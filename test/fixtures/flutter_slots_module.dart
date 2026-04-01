// ignore_for_file: avoid_relative_lib_imports

import '../stubs/grumpy_flutter/lib/grumpy_flutter.dart';

import 'flutter_app.dart';
import 'flutter_support.dart';

class SlotsModule extends Module<AppConfig> {
  @override
  List<FlutterRoute<AppConfig>> get routes => [
    ScreenRoute(path: '/book', view: const FixtureScreen('book')),
    ScreenRoute(path: '/admin', view: const FixtureScreen('admin')),
  ];

  @override
  String get logTag => 'SlotsModule';
}
