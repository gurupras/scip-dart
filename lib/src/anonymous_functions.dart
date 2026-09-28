import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:scip_dart/src/utils.dart';

/// Stable descriptors for the unnamed functions of the indexed package:
/// anonymous functions (closures, function expressions and anonymous method
/// invocations) and generic function types (`T Function<T>(T)`).
///
/// The analyzer gives an anonymous function a [LocalFunctionElement] with no
/// name, so without this table every anonymous function in a file shares the
/// descriptor `<file>/null().`, and the named parameters and type parameters of
/// all of them merge into one symbol per name. A generic function type has no
/// descriptor at all, so its type parameters became `null[T]`: one symbol per
/// name across every file of the package.
///
/// An unnamed function is named after its parent as `<parent>`<anonymous>`(k).`
/// or `<parent>`<function-type>`(k).`, where the parent is the nearest
/// enclosing unnamed function, or else the anchor: the nearest enclosing
/// declaration with a global descriptor. `k` is its 1-based rank in source
/// order among the siblings of the same kind whose parent has the same
/// descriptor. Local functions and local variables are transparent, so they
/// never change a rank. Inserting, deleting or wrapping a closure renames only
/// its later siblings and their descendants (and, for a wrap, the wrapped
/// subtree), and an edit outside the anchor renames nothing.
///
/// A local function would otherwise be `<file>/name().`, shared with every
/// same-named local and top-level function of the file. It is named
/// `<parent>name(k).`, where the parent is its innermost enclosing closure,
/// function type or local function (else the anchor), and `k` its rank among
/// same-named local functions under that parent. It is the parent of the local
/// functions inside it only, so no closure or function type changes name.
class AnonymousFunctions {
  static const _anonymous = '<anonymous>';
  static const _functionType = '<function-type>';

  /// Consulted first: in-library references resolve to the same element.
  final Map<Element, String> _byElement = {};

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

  /// Unnamed functions of an indexed file that have no descriptor (for
  /// example a local function whose name is missing in erroneous code).
  int internalMisses = 0;

  /// Unnamed functions of other packages, which keep the 1.7.0 shape.
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
      final path = unit.unit.declaredFragment?.source.fullName;
      if (path != null) table._paths.add(path);
      unit.unit.accept(_Collector(table, descriptorFor, namespaceFor));
    }
    return table;
  }

  void _record(Element element, Fragment fragment, String d) {
    _byElement[element] = d;
    // Only an anonymous function can be referenced from another document
    // (a stored closure), so only it needs the position key. A function
    // type's type parameters are in scope only inside that type, and its
    // fragment offset can be shared (a curried type) or absent (a fragment
    // built from a summary).
    if (!_isAnonymous(element)) return;
    final path = element.source?.fullName;
    if (path == null) return;
    final byOffset = _byPosition.putIfAbsent(path, () => {});
    final existing = byOffset[fragment.offset];
    if (existing != null && existing != d) {
      keyCollisions++;
      display(
        'Unnamed functions share the key $path@${fragment.offset}: '
        'keeping $existing, not $d',
      );
      return;
    }
    byOffset[fragment.offset] = d;
  }

  /// The descriptor of a function the table [names] in the indexed package,
  /// or null for one outside it (counted as a miss or an external fallback).
  String? descriptorFor(Element element) {
    final d = _byElement[element] ?? _byPositionFor(element);
    if (d != null) return d;
    if (_missed.add(element)) {
      final path = element.source?.fullName;
      if (path != null && _paths.contains(path)) {
        internalMisses++;
        display(
          'Unnamed function without a descriptor in $path: '
          '${element.runtimeType}'
          '${element is LocalFunctionElement ? ' @${element.firstFragment.offset}' : ''}',
        );
      } else {
        externalFallbacks++;
      }
    }
    return null;
  }

  String? _byPositionFor(Element element) {
    if (!_isAnonymous(element)) return null;
    final byOffset = _byPosition[element.source?.fullName];
    return byOffset == null ? null : byOffset[element.firstFragment.offset];
  }

  /// Whether [element] is an unnamed function: an anonymous function or a
  /// generic function type.
  static bool names(Element element) =>
      element is LocalFunctionElement ||
      (element is GenericFunctionTypeElement &&
          element.typeParameters.isNotEmpty);

  static bool _isAnonymous(Element element) =>
      element is LocalFunctionElement && element.name == null;
}

class _Collector extends RecursiveAstVisitor<void> {
  final AnonymousFunctions _table;
  final String? Function(Element) _descriptorFor;
  final String? Function(Element) _namespaceFor;

  /// Descriptors of the enclosing named-by-the-table functions, innermost
  /// last, each marked whether it is a local function. Local functions are
  /// parents of local functions only: closures and function types skip them.
  final List<(String, bool)> _parents = [];

  /// The innermost enclosing parent a closure or function type may have.
  String? get _unnamedParent {
    for (var i = _parents.length - 1; i >= 0; i--) {
      if (!_parents[i].$2) return _parents[i].$1;
    }
    return null;
  }

  /// The innermost enclosing parent a local function may have.
  String? get _localParent => _parents.isEmpty ? null : _parents.last.$1;

  /// (kind, parent descriptor) -> children ranked so far
  final Map<(String, String), int> _ranks = {};

  /// anchor declaration -> its descriptor
  final Map<AstNode, String?> _anchors = {};

  _Collector(this._table, this._descriptorFor, this._namespaceFor);

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    // A local function is named after its innermost enclosing closure,
    // function type or local function, else the anchor, and ranked among the
    // local functions of the same name under that parent, so adding an
    // unrelated local function renames nothing. It is a parent of the local
    // functions inside it only.
    final fragment = node.declaredFragment;
    final element = fragment?.element;
    final name = element?.name;
    if (fragment != null && element is LocalFunctionElement && name != null) {
      final parent = _localParent ?? _anchorOf(node) ?? _fileAnchorOf(element);
      if (parent != null) {
        final key = ('local $name', parent);
        final rank = _ranks[key] = (_ranks[key] ?? 0) + 1;
        final descriptor = '$parent$name($rank).';
        _table._record(element, fragment, descriptor);
        _parents.add((descriptor, true));
        try {
          super.visitFunctionDeclaration(node);
        } finally {
          _parents.removeLast();
        }
        return;
      }
    }
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    if (node.parent is FunctionDeclaration) {
      super.visitFunctionExpression(node);
      return;
    }
    _visitUnnamed(
      AnonymousFunctions._anonymous,
      node,
      node.declaredFragment,
      () => super.visitFunctionExpression(node),
    );
  }

  @override
  void visitAnonymousMethodInvocation(AnonymousMethodInvocation node) {
    // The target is outside the anonymous method, so closures in it are not
    // its children.
    node.target2?.accept(this);
    _visitUnnamed(
      AnonymousFunctions._anonymous,
      node,
      node.declaredFragment,
      () {
        node.parameters?.accept(this);
        node.body.accept(this);
      },
    );
  }

  @override
  void visitGenericFunctionType(GenericFunctionType node) {
    // Only type parameters use a function type's descriptor, so a
    // non-generic function type is transparent: it takes no rank, and an
    // ordinary callback type never renames a generic sibling.
    if (node.typeParameters == null) {
      super.visitGenericFunctionType(node);
      return;
    }
    _visitUnnamed(
      AnonymousFunctions._functionType,
      node,
      node.declaredFragment,
      () => super.visitGenericFunctionType(node),
    );
  }

  void _visitUnnamed(
    String kind,
    AstNode node,
    Fragment? fragment,
    void Function() visitChildren,
  ) {
    final element = fragment?.element;
    final parent = _unnamedParent ?? _anchorOf(node) ?? _fileAnchorOf(element);
    if (fragment == null ||
        element == null ||
        !AnonymousFunctions.names(element) ||
        parent == null) {
      visitChildren();
      return;
    }
    final rank = _ranks[(kind, parent)] = (_ranks[(kind, parent)] ?? 0) + 1;
    final descriptor = '$parent`$kind`($rank).';
    _table._record(element, fragment, descriptor);
    _parents.add((descriptor, false));
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
      final Element? element;
      if (n is Declaration) {
        element = n.declaredFragment?.element;
      } else if (n is VariableDeclarationList && n.variables.isNotEmpty) {
        // A variable's type annotation hangs off its declaration list, not
        // the variable: anchor it at the list's first variable.
        element = n.variables.first.declaredFragment?.element;
      } else {
        continue;
      }
      if (element == null || !_isAnchor(element)) continue;
      final anchor = element;
      final descriptor = _anchors.putIfAbsent(n, () => _descriptorFor(anchor));
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
