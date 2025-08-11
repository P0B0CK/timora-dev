// lib/ui/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:timora/ui/atoms/icon_toggle.dart';
import 'package:timora/ui/atoms/button.dart';
import 'package:timora/ui/atoms/icon.dart';
import 'package:timora/ui/atoms/input_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl  = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timora Theme Demo', style: Theme.of(context).textTheme.titleMedium),
        actions: const [ThemeToggleButton()],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth), // ✅ largeur stable
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // étire les sections
              children: [
                // --- Boutons
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

                // --- Icons preview
                Text('Icons preview', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    AppIcon(assetName: 'assets/icons/settings.svg',        style: AppIconStyle.rounded, tooltip: 'Settings (rounded)'),
                    AppIcon(assetName: 'assets/icons/settings.svg',        style: AppIconStyle.alone,   tooltip: 'Settings (alone)'),
                    AppIcon(assetName: 'assets/icons/account_profile.svg', style: AppIconStyle.rounded, tooltip: 'Profile (rounded)'),
                    AppIcon(assetName: 'assets/icons/account_profile.svg', style: AppIconStyle.alone,   tooltip: 'Profile (alone)'),
                  ],
                ),

                const SizedBox(height: 28),

                // --- Inputs preview (prend toute la largeur)
                Text('Inputs preview', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomInputField(
                      label: 'Email',
                      hint: 'you@domain.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      label: 'Mot de passe',
                      hint: 'Au moins 8 caractères',
                      controller: _passCtrl,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    // États avec message
                    CustomInputField(
                      label: 'Username',
                      hint: '3–16 caractères',
                      controller: TextEditingController(),
                      status: InputStatus.error,
                      message: 'Ce nom est déjà pris.',
                    ),
                    const SizedBox(height: 8),
                    CustomInputField(
                      label: 'Promo code',
                      hint: 'Ex: TIMORA25',
                      controller: TextEditingController(),
                      status: InputStatus.success,
                      message: 'Code appliqué avec succès.',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper
void _noop() {}
