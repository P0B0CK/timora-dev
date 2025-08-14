// FRONTEND
// lib/theme/theme_manager.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'themes.dart';
import 'timora_theme.dart';
import 'colors_extension.dart';

class ThemeManager extends ChangeNotifier {
  ThemeManager({
    ThemeModel? initial,
    List<ThemeModel> catalog = const [],
  })  : _catalog = catalog.isNotEmpty ? catalog : themeCatalog,
        _current = initial ?? (catalog.isNotEmpty ? catalog.first : themeCatalog.first);

  final List<ThemeModel> _catalog;
  ThemeModel _current;
  AppColors? _override;

  ThemeModel get current => _current;
  List<ThemeModel> get catalog => List.unmodifiable(_catalog);
  bool get isDark => _current.isDark;

  ThemeData get themeData => TimoraTheme.build(_current, override: _override);

  // --- Mutations
  void setById(String id) {
    final found = _catalog.firstWhere((t) => t.id == id, orElse: () => _current);
    if (!identical(found, _current)) {
      _current = found;
      notifyListeners();
    }
  }

  /// isBrother : light <-> dark
  void toggleDuo() {
    final siblings = _catalog.where((t) => t.duoId == _current.duoId).toList();
    if (siblings.length < 2) return;
    final other = siblings.firstWhere((t) => t.isDark != _current.isDark, orElse: () => _current);
    if (other.id != _current.id) {
      _current = other;
      notifyListeners();
    }
  }

  void toggleBrother() => toggleDuo();

  void overrideColors(AppColors Function(AppColors) mutate) {
    final baseColors = AppColors.fromThemeModel(_current);
    _override = mutate(baseColors);
    notifyListeners();
  }

  /// Réinitialiser la surcharge
  void clearOverrides() {
    if (_override != null) {
      _override = null;
      notifyListeners();
    }
  }
}
