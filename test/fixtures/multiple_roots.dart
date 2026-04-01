// ignore_for_file: avoid_relative_lib_imports

import '../stubs/grumpy/lib/grumpy.dart';

class MultiConfig {}

class FirstRoot extends RootModule<String, MultiConfig> {
  FirstRoot() : super(MultiConfig());

  @override
  List<Route<String, MultiConfig>> get routes => const [];

  @override
  String get logTag => 'FirstRoot';
}

class SecondRoot extends RootModule<String, MultiConfig> {
  SecondRoot() : super(MultiConfig());

  @override
  List<Route<String, MultiConfig>> get routes => const [];

  @override
  String get logTag => 'SecondRoot';
}
