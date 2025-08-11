// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'theme/theme_manager.dart';
import 'theme/themes.dart';              // themeCatalog (barrel vers theme_model.dart)
import 'app/timora_app.dart';
import 'firebase_options.dart';          // généré par FlutterFire CLI
import 'env.dart';                       // AppConfig (dev/staging/prod)
import 'ui/molecules/loader.dart';       // AppLoader

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// =========
  ///  BACKEND
  /// =========
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// =================
  ///  APP ORIENTATION
  /// =================
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /// ====================
  ///  MULTI ENVIRONMENT
  /// ====================
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

  /// ===============
  ///  APP LAUNCHER
  /// ===============
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(
        initial: themeCatalog.firstWhere((t) => t.id == 'classic-dark'),
      ),
      child: const _Bootstrap(), // ⬅️ gate d’amorçage avec loader
    ),
  );
}

/// ===============
///  LOADER
/// ===============
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
    // Ici tu peux ajouter d’autres inits (Remote Config, prefs, etc.)
    // On impose un petit délai mini pour que le loader soit visible (fluidité).
    await Future.delayed(const Duration(milliseconds: 850));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select<ThemeManager, ThemeData>((m) => m.themeData);

    return FutureBuilder<void>(
      future: _preload,
      builder: (context, snap) {
        // Tant que ce n’est pas prêt → MaterialApp minimal + loader full-screen
        if (snap.connectionState != ConnectionState.done) {
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

        // Prêt → lance l’app
        return const TimoraApp();
      },
    );
  }
}
