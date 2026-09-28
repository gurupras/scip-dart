import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart' as analyzer;
import 'package:analyzer/source/line_info.dart';
import 'package:package_config/package_config.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:scip_dart/src/anonymous_functions.dart';
import 'package:scip_dart/src/kind_generator.dart';
import 'package:scip_dart/src/metadata.dart';
import 'package:scip_dart/src/gen/scip.pb.dart';
import 'package:scip_dart/src/relationship_generator.dart';
import 'package:scip_dart/src/symbol_generator.dart';
import 'package:scip_dart/src/utils.dart';

List<SymbolInformation> globalExternalSymbols = [];

class ScipVisitor extends GeneralizingAstVisitor {
  final String _relativePath;
  final String _projectRoot;
  final LineInfo _lineInfo;
  final List<analyzer.Diagnostic> _analysisErrors;

  final SymbolGenerator _symbolGenerator;

  final List<Occurrence> occurrences = [];
  final List<SymbolInformation> symbols = [];

  ScipVisitor(
    this._relativePath,
    this._projectRoot,
    this._lineInfo,
    this._analysisErrors,
    PackageConfig packageConfig,
    Pubspec pubspec, [
    AnonymousFunctions? anonymousFunctions,
  ]) : _symbolGenerator = SymbolGenerator(
         packageConfig,
         pubspec,
         anonymousFunctions,
       ) {
    final fileSymbol = _symbolGenerator.fileSymbolFor(_relativePath);
    occurrences.add(
      Occurrence(
        symbol: fileSymbol,
        range: [0, 0, 0],
        syntaxKind: SyntaxKind.IdentifierModule,
        symbolRoles: SymbolRole.Definition.value,
      ),
    );
    symbols.add(SymbolInformation(symbol: fileSymbol));
  }

  @override
  void visitNode(AstNode node) {
    // [visitDeclaration] on the [GeneralizingAstVisitor] does not match parameters
    // even though the parameter node extends [Declaration]. This is a workaround
    // to correctly parse all [Declaration] ast nodes.
    if (node is Declaration) {
      _visitDeclaration(node);
    } else if (node is FormalParameter) {
      _visitFormalParameter(node);
    } else if (node is SimpleIdentifier) {
      _visitSimpleIdentifier(node);
    } else if (node is NamedType) {
      _visitNamedType(node);
    } else if (node is ImportPrefixReference) {
      _visitImportPrefixReference(node);
    } else if (node is NamedArgument) {
      _visitNamedArgument(node);
    } else if (node is CatchClauseParameter) {
      _visitCatchClauseParameter(node);
    } else if (node is DeclaredVariablePattern) {
      _visitDeclaredVariablePattern(node);
    }

    super.visitNode(node);
  }

  void _visitDeclaration(Declaration node) {
    final element = _symbolGenerator.elementFor(node);
    if (element == null) return;

    final relationships = relationshipsFor(node, element, _symbolGenerator);

    _registerAsDefinition(element, node, relationships: relationships);
  }

  void _visitFormalParameter(FormalParameter node) {
    final element = _symbolGenerator.elementFor(node);
    if (element == null) return;

    // if the parameter is a `this.someFieldOnThClass`, we need to register
    // it as a reference to said field, as well as a declaration of a parameter.
    if (node is FieldFormalParameter) {
      final fieldElement = (element as FieldFormalParameterElement).field;
      if (fieldElement == null) return;
      _registerAsReference(
        fieldElement,
        node,
        offset: node.name.offset,
        length: node.name.length,
      );

      // non-named parameters are considered 'local' symbols, and when combined
      // with field formal parameters (this.foo), do not contain a declaration.
      // if its not named, do not register it as a definition as well.
      if (!node.isNamed) return;
    }

    _registerAsDefinition(element, node);
  }

  /// The exception and stack trace parameters of a catch clause are neither
  /// declarations nor formal parameters, and their name is a token, so they
  /// are defined here. A wildcard `_` (language 3.7 and later) declares no
  /// binding, so it gets no definition.
  void _visitCatchClauseParameter(CatchClauseParameter node) {
    final fragment = node.declaredFragment;
    final name = fragment?.name;
    if (fragment == null || name == null) return;
    final element = fragment.element;
    final wildcard =
        name == '_' &&
        element.library?.featureSet.isEnabled(Feature.wildcard_variables) ==
            true;
    if (wildcard) return;
    _registerAsDefinition(element, node);
  }

  /// A pattern variable is neither a declaration nor a formal parameter, and
  /// its name is a token, so it is defined here. References to a variable of a
  /// logical-or pattern or a shared case scope resolve to its join variable, so
  /// the definition names the join, while its range stays this pattern's name.
  void _visitDeclaredVariablePattern(DeclaredVariablePattern node) {
    final fragment = node.declaredFragment;
    if (fragment == null || fragment.name == null) return;
    final element = SymbolGenerator.rootJoinOf(fragment.element);
    final joined = element != fragment.element;
    _registerAsDefinition(
      element,
      node,
      nameOffset: node.name.offset,
      nameLength: node.name.length,
      withSymbolInformation: !joined || _joinsDefined.add(element),
    );
  }

  /// Join variables whose SymbolInformation this document already has.
  final Set<Element> _joinsDefined = {};

  void _visitSimpleIdentifier(SimpleIdentifier node) {
    final element = _symbolGenerator.elementFor(node);
    if (element == null) return;

    if (node.inDeclarationContext()) {
      _registerAsDefinition(element, node);
    } else {
      _registerAsReference(
        element,
        node,
        offset: node.offset,
        length: node.name.length,
      );
    }
  }

  void _visitNamedType(NamedType node) {
    final element = _symbolGenerator.elementFor(node);
    if (element == null) return;

    _registerAsReference(
      element,
      node,
      offset: node.name.offset,
      length: node.name.length,
    );
  }

  void _visitImportPrefixReference(ImportPrefixReference node) {
    final element = _symbolGenerator.elementFor(node);
    if (element == null) return;

    _registerAsReference(
      element,
      node,
      offset: node.name.offset,
      length: node.name.length,
    );
  }

  void _visitNamedArgument(NamedArgument node) {
    final element = _symbolGenerator.elementFor(node);
    if (element == null) return;

    _registerAsReference(
      element,
      node,
      offset: node.name.offset,
      length: node.name.length,
    );
  }

  /// Registers the provided [element] as a reference to an existing definition
  ///
  /// [node] refers to the ast node where the reference exists, [element]
  /// is the resolved element of the downstream element.
  ///
  /// If [element] exists outside of the projects source, it will be added to the
  /// [globalExternalSymbols].
  void _registerAsReference(
    Element element,
    AstNode node, {
    required int offset,
    required int length,
  }) {
    final symbol = _symbolGenerator.symbolFor(element);
    if (symbol != null) {
      final meta = getSymbolMetadata(element, offset, _analysisErrors);
      occurrences.add(
        Occurrence(
          range: _lineInfo.getRange(offset, length),
          symbol: symbol,
          diagnostics: meta.diagnostics,
        ),
      );

      if (!element.source!.fullName.startsWith(_projectRoot)) {
        if (!globalExternalSymbols.any(
          (symbolInfo) => symbolInfo.symbol == symbol,
        )) {
          final meta = getSymbolMetadata(element, offset, _analysisErrors);
          globalExternalSymbols.add(
            SymbolInformation(
              symbol: symbol,
              documentation: meta.documentation,
              signatureDocumentation: meta.signatureDocumentation,
              kind: symbolKindFor(element),
            ),
          );
        }
      }
    }
  }

  /// Registers a provided [element] as a definition
  ///
  /// This adds both a symbol, and an occurrence for the element and it's
  /// name
  void _registerAsDefinition(
    Element element,
    AstNode node, {
    List<Relationship>? relationships,
    int? nameOffset,
    int? nameLength,
    bool withSymbolInformation = true,
  }) {
    final symbol = _symbolGenerator.symbolFor(element);
    if (symbol == null) return null;

    final offset = nameOffset ?? element.nameOffset;
    final meta = getSymbolMetadata(element, offset, _analysisErrors);
    if (withSymbolInformation) {
      symbols.add(
        SymbolInformation(
          symbol: symbol,
          documentation: meta.documentation,
          relationships: relationships,
          signatureDocumentation: meta.signatureDocumentation,
          kind: symbolKindFor(element),
        ),
      );
    }

    occurrences.add(
      Occurrence(
        range: _lineInfo.getRange(offset, nameLength ?? element.nameLength),
        symbol: symbol,
        symbolRoles: SymbolRole.Definition.value,
        diagnostics: meta.diagnostics,
        enclosingRange: _lineInfo.getRange(node.offset, node.length),
      ),
    );
  }
}
