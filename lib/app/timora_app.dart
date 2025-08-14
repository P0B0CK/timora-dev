// lib/app/timora_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:timora/services/auth_service.dart';
import 'package:timora/ui/organisms/auth_login.dart';
import 'package:timora/ui/pages/login_page.dart';
import 'package:timora/ui/pages/register_page.dart';
import 'package:timora/ui/pages/home_page.dart';
import 'package:timora/ui/templates/timora_scaffold.dart';
import 'package:timora/ui/molecules/loader.dart';
import 'package:timora/theme/theme_manager.dart';

import 'package:timora/ui/utils/logout_helper.dart';
import 'package:timora/ui/organisms/settings_modal.dart';
import 'package:timora/ui/routes/profile_modal_route.dart';

class TimoraApp extends StatelessWidget {
  const TimoraApp({super.key});

  Widget _buildHomeScaffold(BuildContext context) {
    return TimoraScaffold(
      // callbacks de la barre du bas (centre)
      onPrev: () => debugPrint('prev'),
      onProfile: () => Navigator.pushNamed(context, '/profile'),
      onNext: () => debugPrint('next'),

      // colonne gauche
      onOpenSettings: () => openSettingsModal(context),
      onLogout: () => performLogout(context),

      // contenu
      child: const HomePage(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, tm, _) {
        return MaterialApp(
          title: 'Timora',
          debugShowCheckedModeBanner: false,
          theme: tm.themeData,

          locale: const Locale('fr'),
          supportedLocales: [
            Locale('fr'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => _buildHomeScaffold(context),
            '/profile': (context) => const ProfileModalRoute(),
          },

          home: StreamBuilder<User?>(
            stream: AuthService().userStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AppLoader(
                  logoHeight: 72,
                  inkDropSize: 38,
                  gapBetweenLogoAndLoader: 48,
                  loaderTopGap: 24,
                  fullscreen: true,
                );
              }
              if (snapshot.hasData) {
                return _buildHomeScaffold(context);
              }
              return const AuthLoginPage();
            },
          ),
        );
      },
    );
  }
}
