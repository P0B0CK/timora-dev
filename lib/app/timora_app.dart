// lib/app/timora_app.dart
import 'package:flutter/material.dart';
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

// ✅ handlers
import 'package:timora/ui/utils/logout_helper.dart';
import 'package:timora/ui/organisms/settings_modal.dart';

class TimoraApp extends StatelessWidget {
  const TimoraApp({super.key});

  // Petite fabrique pour éviter de dupliquer la config de TimoraScaffold
  Widget _buildHomeScaffold(BuildContext context) {
    return TimoraScaffold(
      // centre (garde ce que tu veux)
      onPrev: () {},
      onProfile: () {},
      onNext: () {},

      // GAUCHE —> branche les vrais handlers :
      onOpenSettings: () => openSettingsModal(context), // <— OUVRE LA MODALE
      onLogout: () => performLogout(context),           // <— OUVRE LA MODALE CONFIRM

      // droite (exemples, garde/branche à ta guise)
      onCreateCalendar: () {},
      onCreateEvent: () {},
      onManageGroups: () {},
      onShare: () {},

      child: HomePage(
        onPrev: () => debugPrint('prev'),
        onProfile: () => Navigator.pushNamed(context, '/profile'),
        onNext: () => debugPrint('next'),
      ),
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
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),

            // ✅ la route /home utilise la même config câblée
            '/home': (context) => _buildHomeScaffold(context),

            '/profile': (context) => const Placeholder(), // à remplacer
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
                // ✅ même config ici (pas de callbacks vides !)
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
