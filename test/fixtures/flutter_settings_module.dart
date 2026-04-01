// ignore_for_file: avoid_relative_lib_imports

import '../stubs/grumpy_flutter/lib/grumpy_flutter.dart';

import 'flutter_app.dart';
import 'flutter_support.dart';

class SettingsModule extends Module<AppConfig> {
  @override
  List<FlutterRoute<AppConfig>> get routes => [
    ScreenRoute.root(
      view: const FixtureScreen('settings-root'),
      children: [
        ScreenRoute(path: '/profile', view: const FixtureScreen('profile')),
      ],
    ),
  ];

  @override
  String get logTag => 'SettingsModule';
}
