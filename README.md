# grumpy_gen

Source gen to enhance projects using [grumpy](https://github.com/necodeIT/grumpy) or [grumpy_flutter](https://github.com/necodeIT/grumpy_flutter).

## Routes

`grumpy_gen` can generate typed route helpers for any library that declares exactly one concrete `RootModule`.

If the root also extends `AppModule`, the generated output includes Flutter navigation helpers on `BuildContext`. Otherwise it generates only the generic static path API.

### Setup

1. Add a `part` directive to the library that contains the root module.
2. Run `dart run build_runner build`.

Example:

```dart
import 'package:grumpy_flutter/grumpy_flutter.dart';

part 'app.routes.dart';

class App extends AppModule<AppConfig> {
  App(super.cfg);

  @override
  List<FlutterRoute<AppConfig>> get routes => [
    ModuleRoute(path: '/settings', module: Settings()),
    ScreenRoute(path: '/dashboard', view: DashboardScreen()),
  ];

  @override
  Screen get notFoundScreen => NotFoundScreen();

  @override
  Widget buildApp() => const Widget();
}
```

### Generated APIs

For every `RootModule`, `grumpy_gen` emits a `GrumpyRoutes` static container with full-path strings.

Example usage:

```dart
final dashboard = GrumpyRoutes.dashboard;
final advancedSettings = GrumpyRoutes.settings.advanced;
final settingsPrefix = GrumpyRoutes.settings.path;
```

For roots that also extend `AppModule`, `grumpy_gen` additionally emits a typed `BuildContext` extension:

```dart
context.to.dashboard();
context.to.settings.advanced();
context.to.users.id(userId).details();
```

Parameterized path segments are represented as explicit segment methods. A route like `/users/:id/details` becomes:

```dart
GrumpyRoutes.users.id(userId).details
context.to.users.id(userId).details()
```

Module boundaries without a root leaf are still generated as typed namespace objects and expose `.path`, but Flutter `call()` is intentionally not generated for them.

### What Gets Scanned

The generator walks all routes reachable from the root and follows:

- `LeafRoute`
- `ScreenRoute`
- `LeafRoute.root`
- `ScreenRoute.root`
- `ModuleRoute`
- `ShellScreenRoute`
- `Route.root([...])`

Path joining follows the runtime router semantics:

- `ShellScreenRoute` contributes no path segment
- `ModuleRoute` descendants are rooted under the module boundary path
- nested children are flattened into full absolute paths

### Current Limitations

Route generation is intentionally static in v1. The generator currently expects route trees to be declared with direct constructor calls and list literals.

Supported:

```dart
@override
List<FlutterRoute<AppConfig>> get routes => [
  ScreenRoute(path: '/dashboard', view: DashboardScreen()),
  ModuleRoute(path: '/slots', module: Slots()),
];
```

Not supported:

```dart
@override
List<FlutterRoute<AppConfig>> get routes => buildRoutes();
```

or route lists built with control flow or spreads.

If a library contains multiple concrete `RootModule` implementations, generation fails with a clear error.
