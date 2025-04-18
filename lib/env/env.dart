import "package:envied/envied.dart";

part "env.g.dart";

@Envied()
abstract class Env {
  @EnviedField(varName: "TRA_SECRET_KEY", obfuscate: true)
  static String TRA_SECRET_KEY = _Env.TRA_SECRET_KEY;

  @EnviedField(varName: "APP_VERSION", optional: true)
  static String APP_VERSION = _Env.APP_VERSION;
}
