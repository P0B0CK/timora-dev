import 'package:flutter/material.dart';
import 'colors.dart';
import 'theme_tokens.dart';

/// Entrée de registre pour un thème (membre d'un duo via duoId).
class AppThemeEntry {
  final String id;          // ex: "classic-dark"
  final String duoId;       // ex: "classic" (groupe pair)
  final String name;        // ex: "Classic Dark"
  final bool isDark;        // dark = principal
  final bool isPremium;     // premium ?
  final TimoraPalette palette;

  const AppThemeEntry({
    required this.id,
    required this.duoId,
    required this.name,
    required this.isDark,
    required this.isPremium,
    required this.palette,
  });
}

/// Registre des thèmes disponibles (ajoute/retire ici).
const List<AppThemeEntry> _themeCatalog = [
  AppThemeEntry(
    id: 'classic-dark',
    duoId: 'classic',
    name: 'Classic Dark',
    isDark: true,
    isPremium: false,
    palette: timoraClassic,
  ),
  AppThemeEntry(
    id: 'classic-light',
    duoId: 'classic',
    name: 'Classic Light',
    isDark: false,
    isPremium: false,
    palette: timoraClassic,
  ),
  AppThemeEntry(
    id: 'twinbw-dark',
    duoId: 'twinbw',
    name: 'Twin Black',
    isDark: true,
    isPremium: true, // exemple premium
    palette: timoraTwinBW,
  ),
  AppThemeEntry(
    id: 'twinbw-light',
    duoId: 'twinbw',
    name: 'Twin White',
    isDark: false,
    isPremium: true,
    palette: timoraTwinBW,
  ),
];

AppThemeEntry _brotherOf(AppThemeEntry e) {
  return _themeCatalog
      .firstWhere((x) => x.duoId == e.duoId && x.isDark != e.isDark);
}

/// Paramètres dynamiques de rendu du thème (ex: accent interchangeable).
@immutable
class ThemeParams {
  final Color? accent; // null => accent par défaut de la palette
  const ThemeParams({this.accent});

  ThemeParams copyWith({Color? accent}) => ThemeParams(
    accent: accent ?? this.accent,
  );
}

/// Un seul ChangeNotifier pour tout gérer.
class ThemeManager extends ChangeNotifier {
  late AppThemeEntry _current;
  ThemeParams _params = const ThemeParams();

  /// Optionnel :
  /// - [initialThemeId] si tu veux démarrer sur un thème précis
  /// - [initialAccent] si tu veux forcer un accent dès le boot
  ThemeManager({String? initialThemeId, Color? initialAccent}) {
    if (initialThemeId != null) {
      final found = _themeCatalog.where((e) => e.id == initialThemeId);
      _current = found.isNotEmpty
          ? found.first
          : _themeCatalog.firstWhere((e) => e.isDark); // fallback dark
    } else {
      _current = _themeCatalog.firstWhere((e) => e.isDark); // dark = principal
    }
    if (initialAccent != null) {
      _params = _params.copyWith(accent: initialAccent);
    }
  }

  // ======================
  //        GETTERS
  // ======================
  AppThemeEntry get currentEntry => _current;
  bool get isDark => _current.isDark;
  bool get isPremium => _current.isPremium;
  ThemeParams get params => _params;

  /// ThemeData prêt pour MaterialApp.theme
  ThemeData get theme => buildTimoraTheme(
    palette: _current.palette,
    feedback: defaultFeedback,
    isDark: _current.isDark,
  ).copyWith(
    // override d’accent éventuel via tokens
    colorScheme: buildTimoraTheme(
      palette: _current.palette,
      feedback: defaultFeedback,
      isDark: _current.isDark,
    ).colorScheme.copyWith(
      primary: _params.accent ??
          _current.palette.primaryColor, // garde le seed
    ),
  );

  /// Liste simple si tu veux afficher un sélecteur dans l'UI
  List<AppThemeEntry> get available => _themeCatalog;

  // ======================
  //       ACTIONS
  // ======================
  bool setThemeById(String id) {
    final found = _themeCatalog.where((e) => e.id == id);
    if (found.isEmpty) return false;
    if (identical(_current, found.first)) return true;
    _current = found.first;
    notifyListeners();
    return true;
  }

  void toggleBrother() {
    _current = _brotherOf(_current);
    notifyListeners();
  }

  void setAccent(Color? accent) {
    _params = _params.copyWith(accent: accent);
    notifyListeners();
  }

// ======================
//  (Optionnel) Persistance
// ======================
// Tu peux brancher SharedPreferences ici :
// Future<void> loadPrefs() async { ... }
// Future<void> savePrefs() async { ... }
}
