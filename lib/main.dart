// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'theme/theme_manager.dart';
import 'theme/themes.dart';              // pour themeCatalog
import 'app/timora_app.dart';            // ton App root
import 'firebase_options.dart';          // généré par FlutterFire CLI
import 'env.dart';                       // AppConfig (dev/staging/prod)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2) Config d'environnement (lit --dart-define=FLAVOR)
  AppConfig.initializeFromDartDefine();

  // 3) Démarrage de l'app avec le ThemeManager
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(
        initial: themeCatalog.firstWhere((t) => t.id == 'classic-dark'),
      ),
      child: const TimoraApp(),
    ),
  );
}
