import 'package:flutter/material.dart';
import 'package:timora/ui/atoms/icon_toggle.dart';
import 'package:timora/ui/molecules/loader.dart';
import 'package:timora/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required void Function() onPrev, required Future<Object?> Function() onProfile, required void Function() onNext});

  Future<void> _logout(BuildContext context) async {
    try {
      await AuthService().logout();
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Déconnexion impossible: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Démo: loader non-fullscreen
      body: const Padding(
        padding: EdgeInsets.all(50),
        child: AppLoader(
          fullscreen: false,
          logoHeight: 64,
          inkDropSize: 38,
        ),
      ),
    );
  }
}
