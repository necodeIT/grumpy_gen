import 'dart:async';

class RouteContext {
  const RouteContext();
}

abstract class Leaf<T> {
  const Leaf();

  T preview(RouteContext ctx);

  FutureOr<T> content(RouteContext ctx);
}

abstract class Module<RouteType, Config extends Object> {
  List<Route<RouteType, Config>> get routes => const [];

  String get logTag;
}

abstract class RootModule<RouteType, Config extends Object>
    extends Module<RouteType, Config> {
  RootModule(this.cfg);

  final Config cfg;

  Route<RouteType, Config> get root => Route.root(routes);
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

class ModuleRoute<T, Config extends Object> extends Route<T, Config> {
  const ModuleRoute({
    required super.path,
    required this.module,
    super.middleware,
    this.root,
  });

  final Module<T, Config> module;
  final LeafRoute<T, Config>? root;
}
