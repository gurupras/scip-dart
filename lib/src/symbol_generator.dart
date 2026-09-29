import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:package_config/package_config.dart';
import 'package:scip_dart/src/anonymous_functions.dart';
import 'package:scip_dart/src/package_version_cache.dart';
import 'package:scip_dart/src/utils.dart';

/// Generates symbols for a specific file.
///
/// Each sourcefile should use its own instance of `SymbolGenerator`
class SymbolGenerator {
  final PackageConfig _packageConfig;
  final Pubspec _pubspec;

  int _localElementIndex = 0;

  /// A mapping between resolved local [Element]s and the [symbol]
  /// that should be used for the element. If no element is found,
  /// [_localElementIndex] should be used to generate one.
  ///
  /// Use [_localSymbolFor] to generate new local symbols
  Map<Element, String> _localElementRegistry = {};

  /// Descriptors of the package's anonymous functions; null while the table
  /// itself is being built.
  final AnonymousFunctions? _anonymousFunctions;

  SymbolGenerator(
    this._packageConfig,
    this._pubspec, [
    this._anonymousFunctions,
  ]);

  /// The scip descriptor of [element], or null (see [_getDescriptor]).
  String? descriptorFor(Element element) => _getDescriptor(element);

  /// The escaped file namespace of [element]'s source (no trailing `/`).
  String? namespaceFor(Element element) {
    final filePath = _filePathFor(element);
    return filePath == null ? null : _escapeNamespacePath(filePath);
  }

  /// For a given [AstNode], returns the correlating [Element] type
  /// that should be used to generate the symbol
  Element? elementFor(AstNode node) {
    if (node is Declaration) {
      return node.declaredFragment?.element;
    } else if (node is FormalParameter) {
      // if this parameter is a child of a GenericFunctionType (can be a
      // typedef, or a function as a parameter), we don't want to index it
      // as a definition (nothing is defined, just referenced). Return false
      // and let the [_visitSimpleIdentifier] declare the reference
      final parentParameter = node.parent
          ?.thisOrAncestorOfType<GenericFunctionType>();
      if (parentParameter != null) return null;

      return node.declaredFragment?.element;
    } else if (node is NamedType) {
      // `Foo()` constructor invocations reference the (unnamed) constructor,
      // whereas `Foo.bar()` references the class via `Foo`, and the
      // constructor via `bar`
      final parent = node.parent;
      if (parent is ConstructorName && parent.name == null) {
        return parent.element;
      }

      final element = node.element;
      if (element?.source == null) return null;
      return element;
    } else if (node is ImportPrefixReference) {
      return node.element;
    } else if (node is NamedArgument) {
      final element = node.correspondingParameter;
      if (element?.source == null) return null;
      return element;
    } else if (node is SimpleIdentifier) {
      var element = node.element;

      // A SimpleIdentifier with a direct parent of a ConstructorDeclaration
      // is the reference to the class itself. Skip this declaration
      if (node.parent is ConstructorDeclaration) {
        return null;
      }

      // Named constructors: `Foo.bar()`, `bar` is the SimpleIdentifier
      // referencing the constructor
      final parent = node.parent;
      if (parent is ConstructorName && parent.name == node) {
        return parent.element;
      }

      // Both `.loadLibrary()`, and `.call()` are synthetic functions that
      // have no definition. These should therefore should not be indexed.
      if (element is TopLevelFunctionElement && element.isOriginLoadLibrary) {
        return null;
      }
      if (element is MethodElement &&
          !element.isOriginDeclaration &&
          element.name == MethodElement.CALL_METHOD_NAME) {
        return null;
      }

      // [element] for assignment fields is null. If the parent node
      // is a `CompoundAssignmentExpression`, we know this node is referring
      // to an assignment line. In that case, use the read/write element attached
      // to this node instead of the [node]'s element
      if (element == null) {
        final assignmentExpr = node
            .thisOrAncestorOfType<CompoundAssignmentExpression>();
        if (assignmentExpr == null) return null;

        element = assignmentExpr.readElement ?? assignmentExpr.writeElement;
      }

      // When the identifier is a field, the analyzer creates synthetic getters/
      // setters for it. We need to get the backing field.
      if (element is PropertyAccessorElement && element.isOriginVariable) {
        // The values field on enums is synthetic, and has no explicit definition like
        // other fields do. Skip indexing for this case.
        final variable = element.variable;
        if (variable is FieldElement && variable.isOriginEnumValues) {
          return null;
        }

        element = variable;
      }

      // element is null if there's nothing really to do for this node. Example: `void`
      // TODO: One weird issue found: named parameters of external symbols were element.source
      //       EX: `color(path, front: Styles.YELLOW);` where `color` comes from the chalk-dart package
      if (element?.source == null) return null;

      return element;
    }

    display(
      'WARN: Received unknown ast node type in elementFor: '
      '${node.runtimeType} ($node). Skipping',
    );

    return null;
  }

  /// For a given `Element` returns the scip symbol form.
  ///
  /// Returns [null] if symbol cannot be created for provided element
  String? symbolFor(Element element) {
    element = forwardedTarget(element);
    if (element is PatternVariableElement) {
      return _localSymbolFor(rootJoinOf(element));
    }
    if (element is LocalVariableElement) {
      return _localSymbolFor(element);
    }

    // named parameters can be "goto'd" on the consuming symbol, and are not "local"
    if (element is FormalParameterElement && !element.isNamed) {
      return _localSymbolFor(element);
    }

    // A private name is library-scoped, and a library spans its part files:
    // a document-local symbol would cut every use in another part from its
    // definition. A named private element is named like a public one (its
    // namespace is its declaring file, so two libraries' `_f` differ). An
    // element with no name (isPrivate is true for it) stays local, and so
    // does a type parameter `_`, which is a wildcard (language 3.7 and later)
    // that may appear more than once in one list.
    if (element.name == null ||
        (element is TypeParameterElement && element.name == '_')) {
      return _localSymbolFor(element);
    }

    final descriptor = _getDescriptor(element);
    if (descriptor == null) {
      return element.isPrivate ? _localSymbolFor(element) : null;
    }

    // Symbol Form: '<scheme> ' ' <package> ' ' (<descriptor>)+ | 'local ' <local-id>'
    return ['scip-dart', _getPackage(element), descriptor].join(' ');
  }

  String fileSymbolFor(String path) {
    return [
      'scip-dart',
      'pub ${_pubspec.name} ${_pubspec.version}',
      '${_escapeNamespacePath(path)}/',
    ].join(' ');
  }

  /// Returns a scip package symbol for a provided [Element].
  ///
  /// <package>      ::= <manager> ' ' <package-name> ' ' <version>
  /// <scheme>       ::= any UTF-8, escape spaces with double space.
  /// <manager>      ::= same as above, use the placeholder '.' to indicate an empty value
  /// <package-name> ::= same as above
  /// <version>      ::= same as above
  String _getPackage(Element element) {
    if (element.source == null) {
      throw Exception('Not really sure what to do here');
    }

    // sdk packages are not defined within the [_packageConfig], version
    // and name must be handled custom
    if (_isInSdk(element)) {
      final packageName = _pathForSdkElement(element).split('/').first;
      final packageVersion = element.library!.languageVersion.package
          .toString();
      return 'pub $packageName $packageVersion';
    }

    final package = _packageConfig.packageOf(
      Uri.file(element.source!.fullName),
    );
    if (package == null) {
      // this should only happen if the source references a package that is not defined
      // in the pubspec (as a main or transitive dep)
      throw Exception('Unable to find package within packageConfig');
    }

    final packageVersion = PackageVersionCache.versionFor(
      package.root.toFilePath(),
    );
    return 'pub ${package.name} $packageVersion';
  }

  /// Returns a scip symbol descriptor for a provided [Element].
  ///
  ///```
  /// <descriptor>           ::= <namespace> | <type> | <term> | <method> | <type-parameter> | <parameter> | <meta>
  /// <namespace>            ::= <name> '/'
  /// <type>                 ::= <name> '#'
  /// <term>                 ::= <name> '.'
  /// <meta>                 ::= <name> ':'
  /// <method>               ::= <name> '(' <method-disambiguator> ').'
  /// <type-parameter>       ::= '[' <name> ']'
  /// <parameter>            ::= '(' <name> ')'
  /// <name>                 ::= <identifier>
  /// <method-disambiguator> ::= <simple-identifier>
  /// <identifier>           ::= <simple-identifier> | <escaped-identifier>
  /// <simple-identifier>    ::= (<identifier-character>)+
  /// <identifier-character> ::= '_' | '+' | '-' | '$' | ASCII letter or digit
  /// <escaped-identifier>   ::= '`' (<escaped-character>)+ '`'
  /// <escaped-characters>   ::= any UTF-8 character, escape backticks with double backtick.
  /// ```
  String? _getDescriptor(Element element) {
    final filePath = _filePathFor(element);
    if (filePath == null) return null;

    final namespace = _escapeNamespacePath(filePath);

    // Elements the table names (anonymous functions, local functions, generic
    // function types and unnamed extensions of the indexed package) are named
    // after their parent (see [AnonymousFunctions]); others keep the shapes
    // below.
    if (AnonymousFunctions.names(element)) {
      final descriptor = _anonymousFunctions?.descriptorFor(element);
      if (descriptor != null) return descriptor;
    }

    if (element is InterfaceElement || // class, mixin, enum, extension type
        element is TypeAliasElement ||
        element is ExtensionElement) {
      return '$namespace/${element.name}#';
    }

    if (element is ConstructorElement) {
      final className = element.enclosingElement.name;
      final constructorName = element.name != null && element.name != 'new'
          ? element.name
          : '`<constructor>`';
      return '$namespace/$className#$constructorName().';
    }

    if (element is MethodElement) {
      final enclosing = element.enclosingElement;
      if (AnonymousFunctions.isUnnamedExtension(enclosing)) {
        final container = _getDescriptor(enclosing!);
        if (container != null) return '$container${element.name}().';
      }
      final className = enclosing?.name;
      return '$namespace/$className#${element.name}().';
    }

    if (element is TopLevelFunctionElement || element is LocalFunctionElement) {
      return '$namespace/${element.name}().';
    }

    if (element is TopLevelVariableElement || element is PrefixElement) {
      return '$namespace/${element.name}.';
    }

    if (element is TypeParameterElement) {
      final encEle = element.enclosingElement;
      if (encEle == null) return '$namespace/[${element.name}]';
      // A function-typed positional parameter (`T g<T>(T x)`) encloses its
      // type parameters, and has no descriptor of its own (it is local):
      // name them under the parameter's enclosing function instead.
      if (encEle is FormalParameterElement && !encEle.isNamed) {
        final function = encEle.enclosingElement;
        final functionDescriptor = function == null
            ? null
            : _getDescriptor(function);
        if (functionDescriptor != null) {
          return '$functionDescriptor(${encEle.name})[${element.name}]';
        }
      }
      return '${_getDescriptor(encEle)}[${element.name}]';
    }

    // only generate symbols for named parameters, all others are 'local x'
    if (element is FormalParameterElement && element.isNamed) {
      final encEle = element.enclosingElement;
      if (encEle == null) {
        display('Parameter element has null enclosingElement "$element"');
        return null;
      }

      // If the enclosing element is a GenericFunctionTypeElement, the function
      // is a `void Function({String param})` type. For this case, [param]
      // is not indexable, so do not generate a symbol for it
      if (encEle is GenericFunctionTypeElement) return null;

      return '${_getDescriptor(encEle)}(${element.name})';
    }

    if (element is PropertyAccessorElement) {
      final parent = element.enclosingElement;
      final parentName = parent is LibraryElement ? null : parent.name;

      var prefix = '';
      if (element is GetterElement) {
        prefix = '<get>';
      } else if (element is SetterElement) {
        prefix = '<set>';
      }

      if (AnonymousFunctions.isUnnamedExtension(parent)) {
        final container = _getDescriptor(parent);
        if (container != null) {
          return '$container`$prefix${element.variable.name}`.';
        }
      }
      return [
        '$namespace/',
        if (parentName != null) '$parentName#',
        '`$prefix${element.variable.name}`.',
      ].join();
    }

    if (element is FieldElement) {
      final encEle = element.enclosingElement;
      return '${_getDescriptor(encEle)}${element.name}.';
    }

    display(
      '\n'
      'Received unknown type (${element.runtimeType})\n'
      '\tname: ${element.name}\n'
      '\tpath: (${element.source?.fullName})'
      '\n',
    );
    return null;
  }

  /// The path of [element]'s source relative to its package root (or its
  /// `dart:` uri for sdk elements); null when the element has no source.
  String? _filePathFor(Element element) {
    if (element.source == null) {
      display(
        'WARN: Element has null source: '
        '${element.runtimeType} (${element}) ',
      );
      return null;
    }
    final sourcePath = element.source!.fullName;

    if (_isInSdk(element)) return _pathForSdkElement(element);

    final config = _packageConfig.packageOf(Uri.file(sourcePath));
    if (config == null) {
      throw Exception(
        'Could not find package for $sourcePath. Have you run pub get?',
      );
    }
    return sourcePath.substring(config.root.toFilePath().length);
  }

  /// A mixin application (`class A = B with M;`) has no constructors of its
  /// own: analyzer gives it synthetic ones that forward to the superclass's,
  /// which nothing defines. Such a constructor, or one of its parameters,
  /// stands for the constructor or parameter it forwards to (followed through
  /// chained applications). An implicit default constructor of an ordinary
  /// class is synthetic too, but not forwarded, and keeps its own symbol.
  static Element forwardedTarget(Element element) {
    for (var depth = 0; depth < 16; depth++) {
      if (element is ConstructorElement && element.isOriginMixinApplication) {
        final target = element.superConstructor;
        if (target == null) return element;
        element = target;
      } else if (element is FormalParameterElement) {
        final owner = element.enclosingElement;
        if (owner is! ConstructorElement || !owner.isOriginMixinApplication) {
          return element;
        }
        final target = owner.superConstructor;
        if (target == null) return element;
        final parameters = target.formalParameters;
        FormalParameterElement? match;
        if (element.isNamed) {
          for (final p in parameters) {
            if (p.isNamed && p.name == element.name) match = p;
          }
        } else {
          // By declaration: a parameter reached through a generic
          // application (`extends GA<int>`) is a substituted copy.
          final base = element.baseElement;
          final index = owner.formalParameters.indexWhere(
            (p) => p.baseElement == base,
          );
          if (index >= 0 && index < parameters.length) {
            match = parameters[index];
          }
        }
        if (match == null) return element;
        element = match;
      } else {
        return element;
      }
    }
    return element;
  }

  /// The variable a pattern variable joins into, across logical-or patterns
  /// and shared case scopes: every use of a joined variable (definitions, `when`
  /// guards and the shared body) resolves to one of the chain, so they all
  /// name the root.
  static PatternVariableElement rootJoinOf(PatternVariableElement element) {
    final seen = <PatternVariableElement>{element};
    var root = element;
    for (var join = root.join; join != null; join = join.join) {
      if (!seen.add(join)) break;
      root = join;
    }
    return root;
  }

  String _localSymbolFor(Element ele) {
    _localElementRegistry.putIfAbsent(
      ele,
      () => 'local ${_localElementIndex++}',
    );
    return _localElementRegistry[ele]!;
  }

  String _escapeNamespacePath(String path) {
    return path
        .split('/')
        .map((segment) => segment.contains('.') ? '`$segment`' : segment)
        .join('/');
  }

  bool _isInSdk(Element element) {
    return element.library?.isInSdk == true;
  }

  String _pathForSdkElement(Element element) {
    final uri = element.source?.uri;
    if (uri != null) {
      return uri.toString();
    } else {
      throw Exception(
        'Unable to find path to dart sdk element: ${element.source!.fullName}',
      );
    }
  }
}
