// FRONTEND
// lib/settings/widgets/toggle_theme_setting.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timora/theme/theme_manager.dart';
import 'setting_item.dart';

class ToggleThemeSetting extends StatelessWidget {
  const ToggleThemeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔎 écoute fine: ne rebuild que si l’état dark change
    final isDark = context.select<ThemeManager, bool>((m) => m.isDark);

    // ⚙️ actions (pas d'écoute)
    final manager = context.read<ThemeManager>();

    // Optionnel : si jamais tu ajoutes des thèmes “orphelins”, gère l’état disabled ici.
    // Dans notre catalogue, chaque thème a un frère → true.
    const hasBrother = true;

    return SettingItem(
      iconPath: 'assets/icons/contrast_switch.svg',
      label: isDark ? 'Mode sombre' : 'Mode clair',
      value: isDark,
      onChanged: hasBrother ? (_) => manager.toggleBrother() : null,
    );
  }
}
