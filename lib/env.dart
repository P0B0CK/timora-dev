// lib/env.dart
enum AppEnvironment { dev, staging, prod }

class AppConfig {
    final AppEnvironment environment;
    static AppConfig? _instance;

    AppConfig._internal(this.environment);

    static AppConfig get instance {
        assert(
        _instance != null,
        'AppConfig non initialisé. Appelle AppConfig.initialize... dans main() avant runApp().',
        );
        return _instance!;
    }

    static void initialize(AppEnvironment env) {
        _instance = AppConfig._internal(env);
    }

    /// Init depuis --dart-define=FLAVOR=dev|staging|prod
    /// commande
    /// flutter run --flavor dev -t lib/main.dart --dart-define=FLAVOR=dev
    static void initializeFromDartDefine() {
        const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
        switch (flavor.toLowerCase()) {
            case 'prod':
            case 'production':
                initialize(AppEnvironment.prod);
                break;
            case 'staging':
            case 'stage':
                initialize(AppEnvironment.staging);
                break;
            case 'dev':
            default:
                initialize(AppEnvironment.dev);
        }
    }

    AppEnvironment get env => environment;

    // Helpers
    static bool get isDev     => (_instance?.environment ?? AppEnvironment.dev) == AppEnvironment.dev;
    static bool get isStaging => (_instance?.environment ?? AppEnvironment.dev) == AppEnvironment.staging;
    static bool get isProd    => (_instance?.environment ?? AppEnvironment.dev) == AppEnvironment.prod;
}
