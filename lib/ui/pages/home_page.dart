// lib/ui/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:timora/ui/atoms/icon_toggle.dart';
import 'package:timora/ui/atoms/button.dart';
import 'package:timora/ui/atoms/icon.dart'; // ton fichier

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timora Theme Demo', style: Theme.of(context).textTheme.titleMedium),
        actions: const [ThemeToggleButton()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Boutons (⚠️ pas de const ici à cause de _noop)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                AppButton(label: 'Primary',   type: ButtonType.primary,   onPressed: _noop),
                AppButton(label: 'Secondary', type: ButtonType.secondary, onPressed: _noop),
                AppButton(label: 'Outlined',  type: ButtonType.outlined,  onPressed: _noop),
              ],
            ),

            const SizedBox(height: 24),

            // --- Icons preview (ok en const)
            Text('Icons preview', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                // settings — rounded & alone (SVGs depuis assets/icons/)
                AppIcon(assetName: 'assets/icons/settings.svg',         style: AppIconStyle.rounded, tooltip: 'Settings (rounded)'),
                AppIcon(assetName: 'assets/icons/settings.svg',         style: AppIconStyle.alone,   tooltip: 'Settings (alone)'),
                // profile — rounded & alone
                AppIcon(assetName: 'assets/icons/account_profile.svg',  style: AppIconStyle.rounded, tooltip: 'Profile (rounded)'),
                AppIcon(assetName: 'assets/icons/account_profile.svg',  style: AppIconStyle.alone,   tooltip: 'Profile (alone)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper
void _noop() {}
