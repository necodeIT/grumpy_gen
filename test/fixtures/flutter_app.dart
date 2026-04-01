// ignore_for_file: avoid_relative_lib_imports

import '../stubs/grumpy_flutter/lib/grumpy_flutter.dart';

import 'flutter_settings_module.dart';
import 'flutter_slots_module.dart';
import 'flutter_support.dart';
import 'flutter_users_module.dart';

class AppConfig {}

class App extends AppModule<AppConfig> {
  App() : super(AppConfig());

  @override
  List<FlutterRoute<AppConfig>> get routes => [
    ShellScreenRoute(
      shellBuilder: (_, _, child) => child,
      children: [
        ScreenRoute(path: '/dashboard', view: const FixtureScreen('dashboard')),
        ModuleRoute(path: '/slots', module: SlotsModule()),
        ModuleRoute(path: '/settings', module: SettingsModule()),
        ModuleRoute(path: '/users/:id', module: UsersModule()),
      ],
    ),
  ];

  @override
  Widget buildApp() => const Widget();

  @override
  String get logTag => 'App';

  @override
  Screen get notFoundScreen => const FixtureScreen('404');
}
