enum AppEnvironment {
    dev,
    staging,
    prod,
}

class AppConfig {
    final AppEnvironment environment;

    static late AppConfig instance;

    AppConfig._internal(this.environment);

    static void initialize(AppEnvironment env) {
        instance = AppConfig._internal(env);
    }

    AppEnvironment get env => environment;

    static bool get isDev => instance.environment == AppEnvironment.dev;
    static bool get isStating => instance.environment == AppEnvironment.staging;
    static bool get isProd => instance.environment == AppEnvironment.prod;
}