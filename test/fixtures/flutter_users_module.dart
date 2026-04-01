// ignore_for_file: avoid_relative_lib_imports

import '../stubs/grumpy_flutter/lib/grumpy_flutter.dart';

import 'flutter_app.dart';
import 'flutter_support.dart';

class UsersModule extends Module<AppConfig> {
  @override
  List<FlutterRoute<AppConfig>> get routes => [
    ScreenRoute(path: '/details', view: const FixtureScreen('details')),
  ];

  @override
  String get logTag => 'UsersModule';
}
