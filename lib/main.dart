// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/theme_manager.dart';
import 'theme/themes.dart';
import 'app/timora_app.dart';
import 'firebase_options.dart';
import 'env.dart';
import 'ui/molecules/loader.dart';
import 'services/auth_service.dart';
import 'services/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // BACKEND
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ORIENTATION
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // ENV
  const String flavor = String.fromEnvironment('FLAVOR');
  late AppEnvironment environment;
  debugPrint("FLAVOR = $flavor");

  switch (flavor) {
    case 'dev':
      environment = AppEnvironment.dev;
      break;
    case 'staging':
      environment = AppEnvironment.staging;
      break;
    case 'prod':
      environment = AppEnvironment.prod;
      break;
    default:
      throw Exception("Unknown flavor : $flavor");
  }
  AppConfig.initialize(environment);

  // APP LAUNCHER
  runApp(
    // ⬇️ Fournis TOUS les providers AU-DESSUS de TimoraApp
    MultiProvider(
      providers: [
        // Services applicatifs
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UserRepository>(create: (_) => UserRepository()),
        // Thème
        ChangeNotifierProvider(
          create: (_) => ThemeManager(
            initial: themeCatalog.firstWhere((t) => t.id == 'classic-dark'),
          ),
        ),
      ],
      child: const _Bootstrap(), // gate d’amorçage avec loader
    ),
  );
}

class _Bootstrap extends StatefulWidget {
  const _Bootstrap({super.key});
  @override
  State<_Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<_Bootstrap> {
  late final Future<void> _preload;

  @override
  void initState() {
    super.initState();
    _preload = _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 850));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select<ThemeManager, ThemeData>((m) => m.themeData);

    return FutureBuilder<void>(
      future: _preload,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          // Loader plein écran le temps du préchargement
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: const AppLoader(
              logoHeight: 72,
              inkDropSize: 38,
              gapBetweenLogoAndLoader: 48,
              loaderTopGap: 24,
              fullscreen: true,
            ),
          );
        }
        // L’app complète (TimoraApp) voit maintenant AuthService & UserRepository
        return const TimoraApp();
      },
    );
  }
}
