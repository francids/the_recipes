import "package:envied/envied.dart";

part "env.g.dart";

@Envied()
abstract class Env {
  @EnviedField(varName: "APP_VERSION", optional: true)
  static String APP_VERSION = _Env.APP_VERSION;
}
