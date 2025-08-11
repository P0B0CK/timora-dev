// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'theme/theme_manager.dart';
import 'theme/themes.dart';              // pour themeCatalog
import 'app/timora_app.dart';            // ton App root
import 'firebase_options.dart';          // généré par FlutterFire CLI
import 'env.dart';                       // AppConfig (dev/staging/prod)

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
  print("FLAVOR = $flavor");

  switch (flavor) {
    case 'dev' :
      environment = AppEnvironment.dev;
      break;
    case 'staging' :
      environment = AppEnvironment.staging;
      break;
    case 'prod' :
      environment = AppEnvironment.prod;
      break;
    default :
      throw Exception("Unknow flavor : $flavor");
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
      child: const TimoraApp(),
    ),
  );
}
