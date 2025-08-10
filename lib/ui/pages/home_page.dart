import 'package:flutter/material.dart';
import 'package:timora/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // centre verticalement
          children: [
            Text(
              'Bienvenue sur Timora 🎉',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Déconnectez-vous :',
              style: theme.textTheme.bodyLarge,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Se déconnecter',
              iconSize: 44,
              onPressed: () async {
                await AuthService().logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
