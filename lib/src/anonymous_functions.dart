import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:scip_dart/src/utils.dart';

/// Stable descriptors for anonymous functions (closures, function
/// expressions and anonymous method invocations) of the indexed package.
///
/// The analyzer gives an anonymous function a [LocalFunctionElement] with no
/// name, so without this table every anonymous function in a file shares the
/// descriptor `<file>/null().`, and the named parameters and type parameters of
/// all of them merge into one symbol per name.
///
/// An anonymous function is named after its parent as
/// `<parent>`<anonymous>`(k).`, where the parent is the nearest enclosing
/// anonymous function, or else the anchor: the nearest enclosing declaration
/// with a global descriptor. `k` is its 1-based rank in source order among the
/// siblings whose parent has the same descriptor. Local functions and local
/// variables are transparent, so they never change a rank. Inserting, deleting
/// or wrapping a closure renames only its later siblings and their
/// descendants, and an edit outside the anchor renames nothing.
class AnonymousFunctions {
  /// Consulted first: in-library references resolve to the same element.
  final Map<LocalFunctionElement, String> _byElement = {};

  /// source path -> fragment offset -> descriptor. A reference from another
  /// document may resolve to a different element instance for the same
  /// function, so the position is the key that survives.
  final Map<String, Map<int, String>> _byPosition = {};

  /// The files of the indexed package, to tell a miss from an external
  /// function.
  final Set<String> _paths = {};
  final Set<Element> _missed = {};

  /// Two functions with one (path, offset) key; the first keeps the key.
  int keyCollisions = 0;

  /// Anonymous functions of an indexed file that have no descriptor (for
  /// example a local function whose name is missing in erroneous code).
  int internalMisses = 0;

  /// Anonymous functions of other packages, which keep the unnamed shape.
  int externalFallbacks = 0;

  int get length => _byElement.length;

  AnonymousFunctions._();

  /// Builds the table for [units]. [descriptorFor] is the descriptor of a
  /// global-shaped element, and [namespaceFor] the file namespace of an
  /// element (`<ns>/` is the anchor when there is no enclosing declaration).
  factory AnonymousFunctions.build(
    Iterable<ResolvedUnitResult> units,
    String? Function(Element) descriptorFor,
    String? Function(Element) namespaceFor,
  ) {
    final table = AnonymousFunctions._();
    for (final unit in units) {
      table._paths.add(unit.path);
      unit.unit.accept(_Collector(table, descriptorFor, namespaceFor));
    }
    return table;
  }

  void _record(LocalFunctionElement element, Fragment fragment, String d) {
    _byElement[element] = d;
    final path = element.source?.fullName;
    if (path == null) return;
    final byOffset = _byPosition.putIfAbsent(path, () => {});
    final existing = byOffset[fragment.offset];
    if (existing != null && existing != d) {
      keyCollisions++;
      display(
        'Anonymous functions share the key $path@${fragment.offset}: '
        'keeping $existing, not $d',
      );
      return;
    }
    byOffset[fragment.offset] = d;
  }

  /// The descriptor of an anonymous function of the indexed package, or null
  /// for one outside it (counted as a miss or an external fallback).
  String? descriptorFor(LocalFunctionElement element) {
    final d =
        _byElement[element] ??
        _byPosition[element.source?.fullName]?[element.firstFragment.offset];
    if (d != null) return d;
    if (_missed.add(element)) {
      final path = element.source?.fullName;
      if (path != null && _paths.contains(path)) {
        internalMisses++;
        display(
          'Anonymous function without a descriptor at '
          '$path@${element.firstFragment.offset}',
        );
      } else {
        externalFallbacks++;
      }
    }
    return null;
  }

  /// [element] as an anonymous function, or null.
  static LocalFunctionElement? anonymous(Element element) =>
      element is LocalFunctionElement && element.name == null ? element : null;
}

class _Collector extends RecursiveAstVisitor<void> {
  final AnonymousFunctions _table;
  final String? Function(Element) _descriptorFor;
  final String? Function(Element) _namespaceFor;

  /// Descriptors of the enclosing anonymous functions, innermost last.
  final List<String> _parents = [];

  /// parent descriptor -> children ranked so far
  final Map<String, int> _ranks = {};

  /// anchor declaration -> its descriptor
  final Map<AstNode, String?> _anchors = {};

  _Collector(this._table, this._descriptorFor, this._namespaceFor);

  @override
  void visitFunctionExpression(FunctionExpression node) {
    if (node.parent is FunctionDeclaration) {
      super.visitFunctionExpression(node);
      return;
    }
    _visitAnonymous(
      node,
      node.declaredFragment,
      () => super.visitFunctionExpression(node),
    );
  }

  @override
  void visitAnonymousMethodInvocation(AnonymousMethodInvocation node) {
    _visitAnonymous(
      node,
      node.declaredFragment,
      () => super.visitAnonymousMethodInvocation(node),
    );
  }

  void _visitAnonymous(
    AstNode node,
    Fragment? fragment,
    void Function() visitChildren,
  ) {
    final element = fragment?.element;
    final parent = _parents.isNotEmpty
        ? _parents.last
        : _anchorOf(node) ?? _fileAnchorOf(element);
    if (fragment == null ||
        element is! LocalFunctionElement ||
        parent == null) {
      visitChildren();
      return;
    }
    final rank = _ranks[parent] = (_ranks[parent] ?? 0) + 1;
    final descriptor = '$parent`<anonymous>`($rank).';
    _table._record(element, fragment, descriptor);
    _parents.add(descriptor);
    try {
      visitChildren();
    } finally {
      _parents.removeLast();
    }
  }

  String? _fileAnchorOf(Element? element) {
    if (element == null) return null;
    final namespace = _namespaceFor(element);
    return namespace == null ? null : '$namespace/';
  }

  String? _anchorOf(AstNode node) {
    for (AstNode? n = node.parent; n != null; n = n.parent) {
      if (n is! Declaration) continue;
      final element = n.declaredFragment?.element;
      if (element == null || !_isAnchor(element)) continue;
      final descriptor = _anchors.putIfAbsent(n, () => _descriptorFor(element));
      if (descriptor != null) return descriptor;
    }
    return null;
  }

  static bool _isAnchor(Element e) =>
      e is TopLevelFunctionElement ||
      e is MethodElement ||
      e is ConstructorElement ||
      e is PropertyAccessorElement ||
      e is TopLevelVariableElement ||
      e is FieldElement ||
      e is InterfaceElement ||
      e is ExtensionElement ||
      e is TypeAliasElement;
}
