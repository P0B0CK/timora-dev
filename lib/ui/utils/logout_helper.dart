// lib/ui/utils/logout_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timora/services/auth_service.dart';

Future<void> performLogout(BuildContext context) async {
  // 👇 rootNavigator pour garantir la nav depuis la racine (même avec des Navigators imbriqués)
  final nav = Navigator.of(context, rootNavigator: true);
  final messenger = ScaffoldMessenger.of(context);

  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Se déconnecter ?'),
      content: const Text('Vous allez être déconnecté de Timora. Continuer ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false), // ✅ pop sur le navigator du dialog
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true), // ✅
          child: const Text('Se déconnecter'),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  try {
    HapticFeedback.mediumImpact();
    debugPrint('[LogoutHelper] signOut…');
    await AuthService().signOut();
    debugPrint('[LogoutHelper] signOut done, navigate to /login');

    // SnackBar d’info (facultatif)
    messenger.showSnackBar(
      const SnackBar(content: Text('Déconnecté. À bientôt 👋')),
    );

    // 👉 Navigation forcée vers l’écran de login (même si on n’est pas sous le StreamBuilder)
    Future.microtask(() {
      nav.pushNamedAndRemoveUntil('/login', (route) => false);
    });
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('Erreur de déconnexion : $e')),
    );
  }
}
