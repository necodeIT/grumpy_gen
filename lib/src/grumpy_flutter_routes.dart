import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'route_generation.dart';

class GrumpyFlutterRoutesGenerator extends Generator {
  const GrumpyFlutterRoutesGenerator();

  @override
  Future<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final spec = await analyzeRouteLibrary(
      library,
      BuildStepRouteAstResolver(buildStep.resolver),
    );
    if (spec == null || !spec.isFlutterRoot) {
      return null;
    }

    return emitFlutterRoutes(spec);
  }
}
