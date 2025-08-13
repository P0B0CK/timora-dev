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

import '../ui/utils/logout_helper.dart';

class TimoraApp extends StatelessWidget {
  const TimoraApp({super.key});

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
            '/home': (context) => TimoraScaffold(
              onPrev: () {  },
              onProfile: () {  },
              onNext: () {  },
              onOpenSettings: () {  },
              onNotifications: () {  },
              onLogout: () => performLogout(context),
              onCreateCalendar: () {  },
              onCreateEvent: () {  },
              onManageGroups: () {  },
              onShare: () {  },
              child: HomePage(
                onPrev: () => debugPrint('prev'),
                onProfile: () =>
                    Navigator.pushNamed(context, '/profile'), // exemple
                onNext: () => debugPrint('next'),
              ),
            ),
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
                return TimoraScaffold(
                  onPrev: () {  },
                  onProfile: () {  },
                  onNext: () {  },
                  onOpenSettings: () {  },
                  onNotifications: () {  },
                  onLogout: () {  },
                  onCreateCalendar: () {  },
                  onCreateEvent: () {  },
                  onManageGroups: () {  },
                  onShare: () {  },
                  child: HomePage(
                    onPrev: () => debugPrint('prev'),
                    onProfile: () =>
                        Navigator.pushNamed(context, '/profile'),
                    onNext: () => debugPrint('next'),
                  ),
                );
              }
              return const AuthLoginPage();
            },
          ),
        );
      },
    );
  }
}
