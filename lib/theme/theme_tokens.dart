// lib/theme/theme_tokens.dart
import 'package:flutter/material.dart';
import 'colors.dart';

/// ===============================
///  ThemeExtension: TimoraTokens
/// ===============================
/// Expose des "tokens" prêts à consommer dans l'UI.
/// - bg        : fond courant
/// - primary   : accent principal
/// - secondary : accent secondaire
/// - tertiary  : accent tertiaire / surfaces subtiles
/// - textAuto  : texte lisible (auto noir/blanc selon le fond)
/// - textBrand : texte "de marque" (identité visuelle)
@immutable
class TimoraTokens extends ThemeExtension<TimoraTokens> {
  final Color bg;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color textAuto;
  final Color textBrand;

  const TimoraTokens({
    required this.bg,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.textAuto,
    required this.textBrand,
  });

  @override
  TimoraTokens copyWith({
    Color? bg,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? textAuto,
    Color? textBrand,
  }) {
    return TimoraTokens(
      bg: bg ?? this.bg,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      textAuto: textAuto ?? this.textAuto,
      textBrand: textBrand ?? this.textBrand,
    );
  }

  @override
  TimoraTokens lerp(ThemeExtension<TimoraTokens>? other, double t) {
    if (other is! TimoraTokens) return this;
    return TimoraTokens(
      bg: Color.lerp(bg, other.bg, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      textAuto: Color.lerp(textAuto, other.textAuto, t)!,
      textBrand: Color.lerp(textBrand, other.textBrand, t)!,
    );
  }
}

// Choix automatique d'une couleur de texte lisible sur un fond
Color _autoOn(Color bg) =>
    bg.computeLuminance() > 0.5 ? const Color(0xDD000000) : Colors.white;

/// ===============================================
///  Résolution palette -> tokens (duo dark/light)
/// ===============================================
TimoraTokens resolveTokens({
  required TimoraPalette palette,
  required bool isDark,
  Color? overrideAccent,
}) {
  if (isDark) {
    final bg = palette.backgroundColor;
    return TimoraTokens(
      bg: bg,
      primary: overrideAccent ?? palette.primaryColor,
      secondary: palette.secondaryColor,
      tertiary: palette.tertiaryColor,
      textAuto: _autoOn(bg),
      textBrand: palette.textColor,
    );
  } else {
    // Light = "frère" : ajustable selon ta DA
    final bg = palette.tertiaryColor;            // ex: fond clair depuis tertiary
    return TimoraTokens(
      bg: bg,
      primary: overrideAccent ?? palette.primaryColor,
      secondary: palette.backgroundColor,        // swap utile pour contrastes
      tertiary: palette.secondaryColor,
      textAuto: _autoOn(bg),
      textBrand: _autoOn(bg),                     // ou palette.textColor si tu veux forcer la marque
    );
  }
}

/// ===============================================
///  Factory ThemeData (Material 3)
/// ===============================================
ThemeData buildTimoraTheme({
  required TimoraPalette palette,
  required FeedbackPalette feedback,
  required bool isDark,
  Color? accentOverride,
  TextTheme? textTheme, // Injecte tes GoogleFonts si besoin
}) {
  final tokens = resolveTokens(
    palette: palette,
    isDark: isDark,
    overrideAccent: accentOverride,
  );

  final baseScheme = ColorScheme.fromSeed(
    seedColor: tokens.primary,
    brightness: isDark ? Brightness.dark : Brightness.light,
  );

  final scheme = baseScheme.copyWith(
    primary: tokens.primary,
    onPrimary: tokens.textAuto,
    secondary: tokens.secondary,
    onSecondary: tokens.textAuto,
    background: tokens.bg,
    surface: tokens.bg,
    onSurface: tokens.textAuto,
    error: feedback.error,
    onError: tokens.textAuto,
  );

  final baseText = (textTheme ?? const TextTheme()).apply(
    bodyColor: tokens.textBrand,    // style "de marque"
    displayColor: tokens.textBrand,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: scheme.brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: tokens.bg,
    textTheme: baseText,
    extensions: [tokens],
  );
}
