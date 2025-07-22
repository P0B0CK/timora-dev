import 'package:flutter/material.dart';
import '../models/app_theme.dart';
import '../theme/timora_theme.dart';

class ThemeManager extends ChangeNotifier {
  final List<AppTheme> _availableThemes = [
    AppTheme(
      id: 'dark',
      name: 'Dark',
      themeData: TimoraTheme.dark,
      isDark: true,
      hasBrother: 'light',
      isPremium: false,
    ),
    AppTheme(
      id: 'light',
      name: 'Light',
      themeData: TimoraTheme.light,
      isDark: false,
      hasBrother: 'dark',
      isPremium: false,
    ),
    AppTheme(
      id: 'blacktwin',
      name: 'Black Twin',
      themeData: TimoraTheme.blacktwin,
      isDark: true,
      hasBrother: 'whitetwin',
      isPremium: true,
    ),
    AppTheme(
      id: 'whitetwin',
      name: 'White Twin',
      themeData: TimoraTheme.whitetwin,
      isDark: false,
      hasBrother: 'blacktwin',
      isPremium: true,
    ),
  ];

  late AppTheme _currentTheme;

  ThemeManager() {
    _currentTheme = _availableThemes[0];
  }

  AppTheme get currentTheme => _currentTheme;
  List<AppTheme> get themes => _availableThemes;

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
