import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:path/path.dart' as p;
import 'package:package_config/package_config.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:scip_dart/src/anonymous_functions.dart';
import 'package:scip_dart/src/flags.dart';

import 'package:scip_dart/src/gen/scip.pb.dart';
import 'package:scip_dart/src/scip_visitor.dart';
import 'package:scip_dart/src/symbol_generator.dart';
import 'package:scip_dart/src/utils.dart';
import 'package:scip_dart/src/version.dart';

Future<Index> indexPackage(
  String root,
  PackageConfig packageConfig,
  Pubspec pubspec,
) async {
  final dirPath = p.normalize(p.absolute(root));

  final metadata = Metadata(
    projectRoot: Uri.file(dirPath).toString(),
    textDocumentEncoding: TextEncoding.UTF8,
    toolInfo: ToolInfo(
      name: 'scip-dart',
      version: scipDartVersion,
      arguments: [],
    ),
  );

  final allPackageRoots = packageConfig.packages
      .map((package) => p.normalize(package.packageUriRoot.toFilePath()))
      .toList();

  // Compared normalised: `root` may carry a trailing slash, which would put
  // the package's own directory in this list and exclude all of its files.
  final nestedPackages = (await pubspecPathsFor(root))
      .map((path) => p.normalize(p.absolute(p.dirname(path))))
      .where((path) => !p.equals(path, dirPath))
      .toList();

  if (Flags.instance.verbose) print('Ignoring subdirectories: $nestedPackages');

  final collection = AnalysisContextCollection(
    includedPaths: [...allPackageRoots, dirPath],
  );

  if (Flags.instance.performance) print('Analyzing Source');
  final st = Stopwatch()..start();

  // The package's files can span several context roots: in a pub workspace
  // the package directory belongs to the workspace root's context, which also
  // analyzes other packages' lib/ (every package root is an included path),
  // while an analysis_options.yaml in the package gives its lib/ a context of
  // its own. So files are taken from every context, the package directory's
  // own context first to keep its order, and selected by lying within the
  // package directory (contexts that cannot hold such a file, such as
  // dependencies' lib/, are skipped). Each file is resolved by the context
  // that analyzes it.
  final context = collection.contextFor(dirPath);
  // `seen` makes the selection valid for one pass, so it is materialised.
  final seen = <String>{};
  bool overlaps(String root) =>
      p.equals(root, dirPath) ||
      p.isWithin(root, dirPath) ||
      p.isWithin(dirPath, root);
  final resolvedUnitFutures =
      [
            context,
            ...collection.contexts.where(
              (c) => c != context && overlaps(c.contextRoot.root.path),
            ),
          ]
          .expand(
            (c) => c.contextRoot
                .analyzedFiles()
                .where((file) => p.extension(file) == '.dart')
                .where((file) => p.isWithin(dirPath, file))
                // only index dart files of the current dart package, to index
                // nested packages, scip indexing can simply be re-run for that
                // nested package
                .where(
                  (file) =>
                      !nestedPackages.any((nested) => p.isWithin(nested, file)),
                )
                .where(seen.add)
                .map(c.currentSession.getResolvedUnit),
          )
          .toList();

  final resolvedUnits = await Future.wait(resolvedUnitFutures);

  if (Flags.instance.performance) {
    print('Analyzing Source took: ${st.elapsedMilliseconds}ms');
    st.reset();
    print('Parsing Ast');
  }

  // Anonymous functions are named from the whole package before any document
  // is visited, so a reference from another file gets the same symbol even
  // when it resolves to a different element instance for the function.
  final namingSt = Stopwatch()..start();
  final anonymousFunctions = AnonymousFunctions();
  final namingGenerator = SymbolGenerator(
    packageConfig,
    pubspec,
    anonymousFunctions,
  );
  anonymousFunctions.build(
    resolvedUnits.whereType<ResolvedUnitResult>(),
    namingGenerator.descriptorFor,
    namingGenerator.namespaceFor,
  );
  if (Flags.instance.performance) {
    print('Naming unnamed functions took: ${namingSt.elapsedMilliseconds}ms');
  }

  final documents = resolvedUnits.whereType<ResolvedUnitResult>().map((
    resUnit,
  ) {
    final relativePath = p.relative(resUnit.path, from: dirPath);

    final visitor = ScipVisitor(
      relativePath,
      dirPath,
      resUnit.lineInfo,
      resUnit.diagnostics,
      packageConfig,
      pubspec,
      anonymousFunctions,
    );
    resUnit.unit.accept(visitor);

    return Document(
      language: Language.Dart.name,
      relativePath: relativePath,
      occurrences: visitor.occurrences,
      symbols: visitor.symbols,
    );
  }).toList();

  if (Flags.instance.performance) {
    print('Parsing Ast took: ${st.elapsedMilliseconds}ms');
  }

  if (Flags.instance.verbose) {
    print(
      'Unnamed functions: ${anonymousFunctions.length} named, '
      '${anonymousFunctions.keyCollisions} key collisions, '
      '${anonymousFunctions.internalMisses} internal misses, '
      '${anonymousFunctions.externalFallbacks} external fallbacks',
    );
  }

  return Index(
    metadata: metadata,
    documents: documents,
    externalSymbols: globalExternalSymbols,
  );
}
