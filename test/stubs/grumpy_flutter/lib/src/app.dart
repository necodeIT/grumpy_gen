class RouteContext {
  const RouteContext();
}

class Widget {
  const Widget();
}

class BuildContext {
  const BuildContext();
}

class Router<T> {
  const Router();

  dynamic get routeInformationProvider => null;

  static Router<T> of<T>(BuildContext context) => Router<T>();
}

abstract class Leaf<T> {
  const Leaf();

  T preview(RouteContext ctx);

  T content(RouteContext ctx);
}

class Route<T, Config extends Object> {
  const Route({
    required this.path,
    this.children = const [],
    this.middleware = const [],
  });

  factory Route.root(List<Route<T, Config>> children) =>
      Route<T, Config>(path: '/', children: children);

  final String path;
  final List<Route<T, Config>> children;
  final List<Object> middleware;
}

class LeafRoute<T, Config extends Object> extends Route<T, Config> {
  const LeafRoute({
    required super.path,
    required this.view,
    super.middleware,
    super.children,
  });

  const LeafRoute.root(this.view, {super.middleware, super.children})
    : super(path: '/');

  final Leaf<T> view;
}

class ModuleRouteBase<T, Config extends Object> extends Route<T, Config> {
  const ModuleRouteBase({
    required super.path,
    required this.module,
    super.middleware,
    this.root,
  });

  final ModuleBase<T, Config> module;
  final LeafRoute<T, Config>? root;
}

abstract class RootModule<RouteType, Config extends Object> {
  RootModule(this.cfg);

  final Config cfg;

  List<Route<RouteType, Config>> get routes => const [];

  Route<RouteType, Config> get root => Route.root(routes);

  String get logTag;
}

abstract class ModuleBase<RouteType, Config extends Object> {
  List<Route<RouteType, Config>> get routes => const [];

  String get logTag;
}

abstract class Screen extends Leaf<Widget> {
  const Screen();

  Widget buildContent(BuildContext context, RouteContext route);

  Widget buildPreview(BuildContext context, RouteContext route);

  @override
  Widget preview(RouteContext ctx) => const Widget();

  @override
  Widget content(RouteContext ctx) => const Widget();
}

abstract class FlutterRoute<AppConfig extends Object>
    extends Route<Widget, AppConfig> {
  const FlutterRoute({required super.path, super.children, super.middleware});
}

abstract class AppModule<AppConfig extends Object>
    extends RootModule<Widget, AppConfig> {
  AppModule(super.cfg);

  @override
  List<FlutterRoute<AppConfig>> get routes => const [];

  Screen get notFoundScreen;

  Widget buildApp();

  String get initialLocation => '/';

  Object get goRouter => Object();
}

abstract class FeatureModule<AppConfig extends Object>
    extends ModuleBase<Widget, AppConfig> {
  @override
  List<FlutterRoute<AppConfig>> get routes => const [];
}

typedef Module<AppConfig extends Object> = FeatureModule<AppConfig>;

class ScreenRoute<AppConfig extends Object> extends LeafRoute<Widget, AppConfig>
    implements FlutterRoute<AppConfig> {
  ScreenRoute({
    required super.path,
    required super.view,
    super.middleware = const [],
    super.children = const [],
  });

  ScreenRoute.root({
    required Screen view,
    List<Object> middleware = const [],
    List<Route<Widget, AppConfig>> children = const [],
  }) : super.root(view, middleware: middleware, children: children);
}

typedef ShellRouteBuilder =
    Widget Function(BuildContext context, Object state, Widget child);

class ShellScreenRoute<AppConfig extends Object>
    extends Route<Widget, AppConfig>
    implements FlutterRoute<AppConfig> {
  const ShellScreenRoute({
    required this.shellBuilder,
    super.middleware = const [],
    super.children = const [],
  }) : super(path: '');

  final ShellRouteBuilder shellBuilder;
}

class ModuleRoute<AppConfig extends Object>
    extends ModuleRouteBase<Widget, AppConfig>
    implements FlutterRoute<AppConfig> {
  ModuleRoute({
    required super.path,
    required Module<AppConfig> module,
    super.middleware = const [],
    super.root,
  }) : super(module: module);
}
