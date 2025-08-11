// FRONTEND
// lib/theme/theme_manager.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'themes.dart';                 // contient ThemeModel + themeCatalog
import 'timora_theme.dart';           // fabrique ThemeData
import 'colors_extension.dart';       // AppColors (ThemeExtension)

class ThemeManager extends ChangeNotifier {
  ThemeManager({
    ThemeModel? initial,
    List<ThemeModel> catalog = const [],
  })  : _catalog = catalog.isNotEmpty ? catalog : themeCatalog,
        _current = initial ?? (catalog.isNotEmpty ? catalog.first : themeCatalog.first);

  // --- État interne
  final List<ThemeModel> _catalog;
  ThemeModel _current;
  AppColors? _override; // permet de surcharger finement les tokens (ex: primary uniquement)

  // --- Sélecteurs / Getters
  ThemeModel get current => _current;
  List<ThemeModel> get catalog => List.unmodifiable(_catalog);
  bool get isDark => _current.isDark;

  /// ThemeData construit depuis le modèle + éventuelle surcharge de tokens
  ThemeData get themeData => TimoraTheme.build(_current, override: _override);

  // --- Mutations
  /// Activer un thème par son id
  void setById(String id) {
    final found = _catalog.firstWhere((t) => t.id == id, orElse: () => _current);
    if (!identical(found, _current)) {
      _current = found;
      notifyListeners();
    }
  }

  /// Bascule vers le "frère" (même duoId), ex: light <-> dark
  void toggleDuo() {
    final siblings = _catalog.where((t) => t.duoId == _current.duoId).toList();
    if (siblings.length < 2) return;
    final other = siblings.firstWhere((t) => t.isDark != _current.isDark, orElse: () => _current);
    if (other.id != _current.id) {
      _current = other;
      notifyListeners();
    }
  }

  /// Alias pour compat avec ton code existant
  void toggleBrother() => toggleDuo();

  /// Surcharger dynamiquement des couleurs (tokens) sans changer la palette
  /// Exemple: overrideColors((c) => c.copyWith(primary: const Color(0xFF4E7EFF)));
  void overrideColors(AppColors Function(AppColors) mutate) {
    final baseColors = AppColors.fromThemeModel(_current);
    _override = mutate(baseColors);
    notifyListeners();
  }

  /// Réinitialiser la surcharge éventuelle
  void clearOverrides() {
    if (_override != null) {
      _override = null;
      notifyListeners();
    }
  }
}
