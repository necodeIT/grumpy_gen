// ignore_for_file: avoid_relative_lib_imports

import '../stubs/grumpy_flutter/lib/grumpy_flutter.dart';

class FixtureScreen extends Screen {
  const FixtureScreen(this.label) : super();

  final String label;

  @override
  Widget buildContent(BuildContext context, RouteContext route) =>
      const Widget();

  @override
  Widget buildPreview(BuildContext context, RouteContext route) =>
      const Widget();
}
