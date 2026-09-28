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
/// An anonymous function is named after its anchor, the nearest enclosing
/// declaration with a global descriptor, as `<anchor>`<anonymous>`(k).`,
/// where `k` is its 1-based rank by offset among the anonymous functions of
/// the same file whose anchor has the same descriptor. Local functions and
/// local variables are never anchors, so the rank does not depend on them, and
/// an edit outside the anchor never changes it.
class AnonymousFunctions {
  /// source path -> fragment offset -> descriptor
  final Map<String, Map<int, String>> _descriptors = {};

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
      final collector = _Collector(descriptorFor, namespaceFor);
      unit.unit.accept(collector);
      final byAnchor = <String, List<_Found>>{};
      for (final found in collector.found) {
        byAnchor.putIfAbsent(found.anchor, () => []).add(found);
      }
      for (final entry in byAnchor.entries) {
        final list = entry.value..sort((a, b) => a.offset.compareTo(b.offset));
        for (var i = 0; i < list.length; i++) {
          table._descriptors.putIfAbsent(
            list[i].path,
            () => {},
          )[list[i].offset] = '${entry.key}`<anonymous>`(${i + 1}).';
        }
      }
    }
    return table;
  }

  /// The descriptor of an anonymous function of the indexed package, or null
  /// for one outside it.
  String? descriptorFor(LocalFunctionElement element) {
    final path = element.source?.fullName;
    if (path == null) return null;
    return _descriptors[path]?[element.firstFragment.offset];
  }

  static bool isAnonymous(Element element) =>
      element is LocalFunctionElement && element.name == null;
}

class _Found {
  final String path;
  final int offset;
  final String anchor;
  _Found(this.path, this.offset, this.anchor);
}

class _Collector extends RecursiveAstVisitor<void> {
  final String? Function(Element) _descriptorFor;
  final String? Function(Element) _namespaceFor;
  final List<_Found> found = [];

  _Collector(this._descriptorFor, this._namespaceFor);

  @override
  void visitFunctionExpression(FunctionExpression node) {
    if (node.parent is! FunctionDeclaration) _add(node, node.declaredFragment);
    super.visitFunctionExpression(node);
  }

  @override
  void visitAnonymousMethodInvocation(AnonymousMethodInvocation node) {
    _add(node, node.declaredFragment);
    super.visitAnonymousMethodInvocation(node);
  }

  void _add(AstNode node, Fragment? fragment) {
    if (fragment == null) return;
    final path = fragment.element.source?.fullName;
    if (path == null) return;
    final anchor = _anchorOf(node) ?? _fileAnchorOf(fragment.element);
    if (anchor == null) return;
    found.add(_Found(path, fragment.offset, anchor));
  }

  String? _fileAnchorOf(Element element) {
    final namespace = _namespaceFor(element);
    return namespace == null ? null : '$namespace/';
  }

  String? _anchorOf(AstNode node) {
    for (AstNode? n = node.parent; n != null; n = n.parent) {
      if (n is! Declaration) continue;
      final element = n.declaredFragment?.element;
      if (element == null || !_isAnchor(element)) continue;
      final descriptor = _descriptorFor(element);
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
