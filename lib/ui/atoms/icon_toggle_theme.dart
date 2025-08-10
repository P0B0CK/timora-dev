// FRONTEND
// lib/ui/atoms/icon_toggle_theme.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timora/theme/theme_manager.dart';
import 'package:timora/theme/theme_tokens.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    // rebuild uniquement quand le mode (dark/light) change
    final isDark = context.select<ThemeManager, bool>((m) => m.isDark);

    // couleur d’icône : token primaire si dispo, sinon colorScheme.primary
    final tokens = Theme.of(context).extension<TimoraTokens>();
    final Color iconColor = tokens?.primary ?? Theme.of(context).colorScheme.primary;

    return IconButton(
      tooltip: 'Basculer thème clair/sombre',
      icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: iconColor),
      onPressed: () => context.read<ThemeManager>().toggleBrother(),
    );
  }
}
