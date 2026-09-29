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
    } else if (node is AssignedVariablePattern) {
      _visitAssignedVariablePattern(node);
    } else if (node is PrimaryConstructorDeclaration) {
      _visitPrimaryConstructorDeclaration(node);
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

      // The parameter is defined as well, named or positional: the
      // initializer list refers to the parameter, not the field.
    }

    // `super.x` forwards to a parameter of the super constructor, which it
    // references: a named one by its symbol. A positional one is local to its
    // own document, so a field-formal target is referenced by its field.
    if (node is SuperFormalParameter &&
        element is SuperFormalParameterElement) {
      final forwarded = element.superConstructorParameter;
      final target = forwarded == null
          ? null
          : SymbolGenerator.forwardedTarget(forwarded)
                as FormalParameterElement;
      final Element? referenced = target == null
          ? null
          : target.isNamed
          ? target
          : target is FieldFormalParameterElement
          ? target.field
          : null;
      if (referenced != null) {
        _registerAsReference(
          referenced,
          node,
          offset: node.name.offset,
          length: node.name.length,
        );
      }
    }

    // A declaring parameter of a primary constructor (`final int x` in a
    // class, enum or extension type header, including an extension type's
    // representation) declares its field too, and every use of the field
    // refers to that field.
    final name = node.name;
    if (element is FieldFormalParameterElement &&
        element.isDeclaring &&
        name != null) {
      final field = element.field;
      if (field != null) {
        _registerAsDefinition(
          field,
          node,
          nameOffset: name.offset,
          nameLength: name.length,
        );
      }
    }

    // The range is the name token: a private named parameter (`this._x`) is
    // named `x`, so the element's name is shorter than the token.
    _registerAsDefinition(
      element,
      node,
      nameOffset: name?.offset,
      nameLength: name?.length,
    );
  }

  /// A primary constructor (in a class, enum or extension type header) is not
  /// a declaration node, so it is defined here: at its name when it has one
  /// (`X._`, `X.new`), else at the type name, as the Dart IDE does.
  void _visitPrimaryConstructorDeclaration(PrimaryConstructorDeclaration node) {
    final element = node.declaredFragment?.element;
    if (element == null) return;
    final name = node.constructorName?.name ?? node.typeName;
    _registerAsDefinition(
      element,
      node,
      nameOffset: name.offset,
      nameLength: name.length,
    );
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

  /// The variable a pattern assignment (`(a, b) = (b, a)`) writes to is named
  /// by a token, not an identifier, so its reference is emitted here.
  void _visitAssignedVariablePattern(AssignedVariablePattern node) {
    // In valid code the target is a local variable or a parameter; code that
    // does not compile can resolve to an accessor, which is not defined.
    final element = node.element;
    if (element == null ||
        (element is! LocalVariableElement &&
            element is! FormalParameterElement)) {
      return;
    }
    _registerAsReference(
      element,
      node,
      offset: node.name.offset,
      length: node.name.length,
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
