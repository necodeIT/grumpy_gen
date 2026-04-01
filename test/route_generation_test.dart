import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/dart/ast/utilities.dart';
import 'package:grumpy_gen/grumpy_gen.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  late _ResolvedFixtureLoader loader;

  setUpAll(() {
    loader = _ResolvedFixtureLoader(Directory.current.path);
  });

  test('generic root emits only GrumpyRoutes', () async {
    final library = await loader.libraryFor('test/fixtures/generic_root.dart');
    final spec = await analyzeRouteLibrary(
      LibraryReader(library.element),
      _TestRouteAstResolver(loader.session),
    );

    expect(spec, isNotNull);
    expect(spec!.isFlutterRoot, isFalse);

    final generic = emitGenericRoutes(spec);
    final flutter = emitFlutterRoutes(spec);

    expect(generic, contains('abstract final class GrumpyRoutes'));
    expect(generic, contains('static String get dashboard => \'/dashboard\';'));
    expect(
      generic,
      contains(
        'static _InventoryRoutes get inventory => const _InventoryRoutes(\'/inventory\');',
      ),
    );
    expect(
      generic,
      contains('String get audit => _grumpyJoinPath(_path, \'audit\');'),
    );
    expect(generic, contains('_ItemsIdRoutes id(String id) => _ItemsIdRoutes'));
    expect(flutter, isEmpty);
  });

  test('flutter root emits generic and context navigation APIs', () async {
    final library = await loader.libraryFor('test/fixtures/flutter_app.dart');
    final spec = await analyzeRouteLibrary(
      LibraryReader(library.element),
      _TestRouteAstResolver(loader.session),
    );

    expect(spec, isNotNull);
    expect(spec!.isFlutterRoot, isTrue);

    final generic = emitGenericRoutes(spec);
    final flutter = emitFlutterRoutes(spec);

    expect(generic, contains('abstract final class GrumpyRoutes'));
    expect(generic, contains('static String get dashboard => \'/dashboard\';'));
    expect(
      generic,
      contains(
        'Warning: this module has no root leaf, so this node is a namespace/path holder only.',
      ),
    );
    expect(
      generic,
      contains(
        'static _UsersRoutes get users => const _UsersRoutes(\'/users\');',
      ),
    );

    expect(
      flutter,
      contains('extension AppRoutesBuildContextX on BuildContext'),
    );
    expect(flutter, contains('void dashboard() => _go(\'/dashboard\');'));
    expect(
      flutter,
      contains(
        'void book() => _routeInformationProvider(_context).go(_grumpyJoinPath(_path, \'book\'));',
      ),
    );
    expect(
      flutter,
      contains('void call() => _routeInformationProvider(_context).go(_path);'),
    );
    expect(
      flutter,
      contains(
        '_UsersIdContextRoutes id(String id) => _UsersIdContextRoutes(_context, _grumpyJoinPath(_path, Uri.encodeComponent(id)));',
      ),
    );
  });

  test('multiple root modules fail clearly', () async {
    final library = await loader.libraryFor(
      'test/fixtures/multiple_roots.dart',
    );

    await expectLater(
      () => analyzeRouteLibrary(
        LibraryReader(library.element),
        _TestRouteAstResolver(loader.session),
      ),
      throwsA(
        isA<InvalidGenerationSource>().having(
          (error) => error.message,
          'message',
          contains('Expected exactly one concrete RootModule'),
        ),
      ),
    );
  });

  test('dynamic routes fail clearly', () async {
    final library = await loader.libraryFor(
      'test/fixtures/dynamic_routes.dart',
    );

    await expectLater(
      () => analyzeRouteLibrary(
        LibraryReader(library.element),
        _TestRouteAstResolver(loader.session),
      ),
      throwsA(
        isA<InvalidGenerationSource>().having(
          (error) => error.message,
          'message',
          contains('Expected a list literal'),
        ),
      ),
    );
  });
}

final class _ResolvedFixtureLoader {
  _ResolvedFixtureLoader(this.packageRoot)
    : _collection = AnalysisContextCollection(includedPaths: [packageRoot]);

  final String packageRoot;
  final AnalysisContextCollection _collection;

  AnalysisSession get session =>
      _collection.contextFor(packageRoot).currentSession;

  Future<ResolvedLibraryResult> libraryFor(String relativePath) async {
    final path = '$packageRoot/$relativePath';
    final context = _collection.contextFor(path);
    final result = await context.currentSession.getResolvedLibrary(path);
    if (result is! ResolvedLibraryResult) {
      throw StateError('Failed to resolve $relativePath.');
    }
    return result;
  }
}

final class _TestRouteAstResolver implements RouteAstResolver {
  _TestRouteAstResolver(this._session);

  final AnalysisSession _session;
  final Map<String, ResolvedLibraryResult> _libraries =
      <String, ResolvedLibraryResult>{};

  @override
  Future<AstNode?> astNodeFor(Fragment fragment) async {
    final libraryPath = fragment.element.library!.firstFragment.source.fullName;
    final resolvedLibrary = await _resolvedLibrary(libraryPath);
    final unitPath = fragment.libraryFragment?.source.fullName ?? libraryPath;
    final unit = resolvedLibrary.unitWithPath(unitPath);
    if (unit == null) {
      return null;
    }

    final node = NodeLocator2(fragment.offset).searchWithin(unit.unit);
    return node;
  }

  Future<ResolvedLibraryResult> _resolvedLibrary(String libraryPath) async {
    final cached = _libraries[libraryPath];
    if (cached != null) {
      return cached;
    }

    final result = await _session.getResolvedLibrary(libraryPath);
    if (result is! ResolvedLibraryResult) {
      throw StateError('Failed to resolve $libraryPath.');
    }

    _libraries[libraryPath] = result;
    return result;
  }
}
