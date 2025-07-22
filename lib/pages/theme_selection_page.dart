import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_manager.dart';
import '../models/app_theme.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();
    final themes = themeManager.themes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection du thème'),
      ),
      body: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final appTheme = themes[index];
          final isCurrent = appTheme.id == themeManager.currentTheme.id;

          return ListTile(
            leading: Icon(
              isCurrent ? Icons.check_circle : Icons.circle_outlined,
              color: isCurrent
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            title: Text(appTheme.name),
            subtitle: Text(appTheme.isPremium ? 'Premium' : 'Gratuit'),
            trailing: appTheme.isPremium
                ? const Icon(Icons.lock, color: Colors.amber)
                : null,
            onTap: () {
              if (appTheme.isPremium) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thème premium – pas encore débloqué !'),
                  ),
                );
                // 🛒 Plus tard : intégrer le flux d’achat
              } else {
                themeManager.setTheme(appTheme);
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );
  }
}