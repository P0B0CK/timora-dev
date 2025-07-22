import 'package:flutter/material.dart';
import 'theme_manager.dart';
import '../models/app_theme.dart';

class ThemeSwitcher extends ChangeNotifier {
  ThemeManager _themeManager;

  ThemeSwitcher(this._themeManager);

  // Accès au thème actuel
  AppTheme get currentTheme => _themeManager.currentTheme;

  // Retourne true si le thème actuel est dark
  bool get isDark => currentTheme.isDark;

  // Bascule vers le thème frère (clair/sombre)
  void toggleThemeMode() {
    final current = currentTheme;
    final brotherId = current.hasBrother;

    if (brotherId == null) {
      debugPrint('⚠️ Aucun thème frère défini pour "${current.id}".');
      return;
    }

    try {
      final brotherTheme = _themeManager.themes.firstWhere(
            (t) => t.id == brotherId,
        orElse: () {
          debugPrint('❌ Thème frère "$brotherId" introuvable.');
          return current; // on reste sur le même thème
        },
      );

      if (brotherTheme.id != current.id) {
        _themeManager.setTheme(brotherTheme);
        notifyListeners();
        debugPrint('🌓 Switch vers le thème "${brotherTheme.id}"');
      }
    } catch (e) {
      debugPrint('💥 Erreur lors du switch de thème : $e');
    }
  }

  // Change explicitement de thème par ID
  void switchTo(String id) {
    try {
      final target = _themeManager.themes.firstWhere((t) => t.id == id);
      _themeManager.setTheme(target);
      notifyListeners();
      debugPrint('🎨 Switch explicite vers "$id"');
    } catch (e) {
      debugPrint('❌ Thème "$id" introuvable : $e');
    }
  }

  // Setter utilisé par ProxyProvider
  set themeManager(ThemeManager manager) {
    _themeManager = manager;
    notifyListeners();
  }
}
