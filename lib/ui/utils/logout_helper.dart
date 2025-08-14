// lib/ui/utils/logout_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timora/services/auth_service.dart';
import 'package:timora/ui/molecules/app_modal.dart';

/// Déconnecte l'utilisateur
Future<void> performLogout(BuildContext context, {bool forceToLogin = false}) async {
  debugPrint('[LogoutHelper] performLogout called (mounted=${context.mounted})');

  // ✅ Récupère le root navigator + son overlay (context garanti)
  final rootNav = Navigator.of(context, rootNavigator: true);
  final safeContext = rootNav.overlay?.context ?? context;

  // ✅ Récupère un ScaffoldMessenger même si `context` n’en a pas
  final messenger = ScaffoldMessenger.maybeOf(context)
      ?? ScaffoldMessenger.maybeOf(safeContext)
      ?? ScaffoldMessenger.of(safeContext);

  debugPrint('[LogoutHelper] opening confirm modal…');
  final confirm = await showAppConfirmDialog(
    context: safeContext,
    title: 'Se déconnecter ?',
    message: 'Vous allez être déconnecté de Timora. Continuer ?',
    confirmLabel: 'Se déconnecter',
    cancelLabel: 'Annuler',
    useRootNavigator: true,
  );

  debugPrint('[LogoutHelper] confirm result = $confirm');
  if (confirm != true) return;

  try {
    HapticFeedback.mediumImpact();
    debugPrint('[LogoutHelper] signOut…');
    await AuthService().signOut();
    debugPrint('[LogoutHelper] signOut done');

    messenger.showSnackBar(
      const SnackBar(content: Text('Déconnecté. À bientôt 👋')),
    );

    if (forceToLogin) {
      debugPrint('[LogoutHelper] forceToLogin -> /login');
      Future.microtask(() {
        rootNav.pushNamedAndRemoveUntil('/login', (route) => false);
      });
    }
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('Erreur de déconnexion : $e')),
    );
  }
}
