// App Root
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:timora/services/auth_service.dart';
import 'package:timora/ui/organisms/login_page.dart';
import 'package:timora/ui/organisms/register_page.dart';
import 'package:timora/ui/pages/home_page.dart';
import 'package:timora/ui/templates/timora_scaffold.dart';

// ✅ nouveau manager unifié
import 'package:timora/theme/theme_manager.dart';

class TimoraApp extends StatelessWidget {
  const TimoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, tm, _) {
        return MaterialApp(
          title: 'Timora',
          debugShowCheckedModeBanner: false,
          // ✅ le ThemeData vient directement du manager
          theme: tm.theme,
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const TimoraScaffold(child: HomePage()),
          },
          home: StreamBuilder<User?>(
            stream: AuthService().userStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData) {
                // ✅ Utilise TimoraScaffold pour inclure les barres
                return const TimoraScaffold(child: HomePage());
              }
              return const LoginPage();
            },
          ),
        );
      },
    );
  }
}
