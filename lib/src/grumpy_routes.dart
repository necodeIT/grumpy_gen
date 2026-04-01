import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'grumpy_flutter_routes.dart';
import 'route_generation.dart';

Builder grumpyRoutesBuilder(BuilderOptions options) => PartBuilder(
  const [GrumpyRoutesGenerator(), GrumpyFlutterRoutesGenerator()],
  '.routes.dart',
  options: options,
);

class GrumpyRoutesGenerator extends Generator {
  const GrumpyRoutesGenerator();

  @override
  Future<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final spec = await analyzeRouteLibrary(
      library,
      BuildStepRouteAstResolver(buildStep.resolver),
    );
    if (spec == null) {
      return null;
    }

    return emitGenericRoutes(spec);
  }
}
