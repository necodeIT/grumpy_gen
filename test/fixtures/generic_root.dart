// ignore_for_file: avoid_relative_lib_imports

import 'dart:async';

import '../stubs/grumpy/lib/grumpy.dart';

class GenericConfig {}

class GenericLeaf extends Leaf<String> {
  @override
  FutureOr<String> content(RouteContext ctx) => 'content';

  @override
  String preview(RouteContext ctx) => 'preview';
}

class InventoryModule extends Module<String, GenericConfig> {
  @override
  List<Route<String, GenericConfig>> get routes => [
    LeafRoute.root(
      GenericLeaf(),
      children: [LeafRoute(path: '/audit', view: GenericLeaf())],
    ),
  ];

  @override
  String get logTag => 'InventoryModule';
}

class ItemsModule extends Module<String, GenericConfig> {
  @override
  List<Route<String, GenericConfig>> get routes => [
    LeafRoute(path: '/details', view: GenericLeaf()),
  ];

  @override
  String get logTag => 'ItemsModule';
}

class GenericRoot extends RootModule<String, GenericConfig> {
  GenericRoot() : super(GenericConfig());

  @override
  List<Route<String, GenericConfig>> get routes => [
    LeafRoute(path: '/dashboard', view: GenericLeaf()),
    ModuleRoute(path: '/inventory', module: InventoryModule()),
    ModuleRoute(path: '/items/:id', module: ItemsModule()),
  ];

  @override
  String get logTag => 'GenericRoot';
}
