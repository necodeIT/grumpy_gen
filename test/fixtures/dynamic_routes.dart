// ignore_for_file: avoid_relative_lib_imports

import 'dart:async';

import '../stubs/grumpy/lib/grumpy.dart';

class DynamicConfig {}

class DynamicLeaf extends Leaf<String> {
  @override
  FutureOr<String> content(RouteContext ctx) => 'content';

  @override
  String preview(RouteContext ctx) => 'preview';
}

class DynamicRoot extends RootModule<String, DynamicConfig> {
  DynamicRoot() : super(DynamicConfig());

  @override
  List<Route<String, DynamicConfig>> get routes => buildRoutes();

  List<Route<String, DynamicConfig>> buildRoutes() => [
    LeafRoute(path: '/dashboard', view: DynamicLeaf()),
  ];

  @override
  String get logTag => 'DynamicRoot';
}
