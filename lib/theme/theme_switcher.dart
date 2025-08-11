// lib/theme/theme_switcher.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_manager.dart';

class ThemeSwitcher extends StatelessWidget {
  final Widget child;
  const ThemeSwitcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (_, manager, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: manager.themeData,
          // Si tu veux fournir aussi darkTheme séparée, tu peux générer la sœur ici :
          // darkTheme: TimoraTheme.build(manager.catalog.firstWhere((t)=> t.duoId==manager.current.duoId && t.isDark)),
          home: child,
        );
      },
    );
  }
}
