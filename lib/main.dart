import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'env.dart';
import 'app/timora_app.dart';

// ✅ Nouveau manager unifié
import 'theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔧 Gestion de l’environnement avec fallback sûr
  const String rawFlavor = String.fromEnvironment('FLAVOR');
  final String flavor = (rawFlavor.isEmpty) ? 'dev' : rawFlavor;
  debugPrint("FLAVOR = $flavor");

  final environment = switch (flavor) {
    'dev' => AppEnvironment.dev,
    'staging' => AppEnvironment.staging,
    'prod' => AppEnvironment.prod,
    _ => AppEnvironment.dev, // fallback final
  };

  AppConfig.initialize(environment);

  // 🔒 Orientation uniquement portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 🚀 Lancement de l'app
  runApp(
    ChangeNotifierProvider<ThemeManager>(
      // Optionnel: ThemeManager(initialThemeId: 'classic-dark')
      create: (_) => ThemeManager(),
      child: const TimoraApp(), // 🧠 Auth + Routing + App UI
    ),
  );
}
