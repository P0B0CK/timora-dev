import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/theme_manager.dart';
import 'providers/theme_switcher.dart';
import 'pages/home_page.dart';
import 'ui/organisms/app_top_bar.dart';
import 'ui/organisms/app_bottom_bar.dart';

import 'env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

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

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);



  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeManager()),
          ChangeNotifierProxyProvider<ThemeManager, ThemeSwitcher>(
            create: (context) => ThemeSwitcher(context.read<ThemeManager>()),
            update: (context, themeManager, previous) =>
            previous!..themeManager = themeManager,
          ),
        ],
        child: const TimoraApp(),
      )

  );
}

class TimoraApp extends StatelessWidget {
  final String environment ="dev";

  const TimoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, _) {
        return MaterialApp(
          title: 'Timora',
          debugShowCheckedModeBanner: false,
          theme: themeManager.currentTheme.themeData,
          home: const MainLayout(),
        );
      },
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(), // ta top bar personnalisée
      body: const HomePage(),    // ton contenu principal
      bottomNavigationBar: const AppBottomBar(), // ta bottom bar personnalisée
    );
  }
}
