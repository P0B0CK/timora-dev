import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_manager.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();
    final isDark = themeManager.currentTheme.id == 'dark';
    final primaryColor = Theme.of(context).colorScheme.primary;

    return IconButton(
      icon: Icon(
        isDark ? Icons.dark_mode : Icons.light_mode,
        color: primaryColor, // ✅ forcer la couleur principale sur l’icône
      ),
      onPressed: () {
        final newTheme = isDark
            ? themeManager.themes.firstWhere((t) => t.id == 'light')
            : themeManager.themes.firstWhere((t) => t.id == 'dark');
        themeManager.setTheme(newTheme);
      },
      tooltip: 'Basculer thème clair/sombre',
    );
  }
}
