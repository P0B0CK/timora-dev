// lib/theme/timora_theme.dart
import 'package:flutter/material.dart';
import 'colors_extension.dart'; // barrel -> export 'app_colors_extension.dart'
import 'themes.dart';           // barrel -> export 'theme_model.dart'
import 'fonts.dart';

class TimoraTheme {
  static ThemeData build(ThemeModel model, {AppColors? override}) {
    final appColors = override ?? AppColors.fromThemeModel(model);

    // Ne plus passer `background:` -> utiliser `surface` uniquement
    final colorScheme = ColorScheme.fromSeed(
      seedColor: appColors.primary,
      brightness: model.isDark ? Brightness.dark : Brightness.light,
      surface: appColors.surface,
    ).copyWith(
      primary: appColors.primary,
      onPrimary: appColors.onPrimary,
      secondary: appColors.secondary,
      onSecondary: appColors.onSecondary,
      tertiary: appColors.tertiary,
      onTertiary: appColors.onTertiary,
      error: appColors.error,
      onError: Colors.white,
      // pas de background / onBackground -> privilégier surface / onSurface
      surface: appColors.surface,
      onSurface: appColors.onSurface,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // couleur de page -> via token, pas via ColorScheme.background
      scaffoldBackgroundColor: appColors.background,
      extensions: [appColors],

      // Typo
      textTheme: TextTheme(
        displayLarge: TimoraTextStyles.displayLarge.copyWith(color: appColors.onBackground),
        headlineMedium: TimoraTextStyles.headlineMedium.copyWith(color: appColors.onBackground),
        titleMedium: TimoraTextStyles.titleMedium.copyWith(color: appColors.onSurface),
        bodyLarge: TimoraTextStyles.bodyLarge.copyWith(color: appColors.onSurface),
        labelLarge: TimoraTextStyles.labelLarge.copyWith(color: appColors.onSurface),
      ),

      dividerTheme: DividerThemeData(color: appColors.divider, thickness: 1),

      cardTheme: CardThemeData(
        color: appColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: appColors.outline),
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Reste utile si tu utilises des TextField "classiques"
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.surface,
        hintStyle: TextStyle(color: appColors.onSurface.withOpacity(0.6)),
        labelStyle: TextStyle(color: appColors.onSurface),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: appColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: appColors.focus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: appColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: appColors.error, width: 2),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: appColors.surface,
        selectedColor: appColors.primary.withOpacity(0.18),
        disabledColor: appColors.disabled,
        labelStyle: TextStyle(color: appColors.onSurface),
        secondaryLabelStyle: TextStyle(color: appColors.onPrimary),
        side: BorderSide(color: appColors.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      // Buttons (WidgetStateProperty au lieu de MaterialStateProperty)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return appColors.disabled;
            return appColors.primary;
          }),
          foregroundColor: WidgetStateProperty.all(appColors.onPrimary),
          overlayColor: WidgetStateProperty.all(appColors.primary.withOpacity(0.08)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.resolveWith((states) {
            return BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? appColors.disabled
                  : appColors.outline,
            );
          }),
          foregroundColor: WidgetStateProperty.all(appColors.onSurface),
          overlayColor: WidgetStateProperty.all(appColors.focus.withOpacity(0.12)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(appColors.primary),
          overlayColor: WidgetStateProperty.all(appColors.primary.withOpacity(0.08)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return appColors.primary;
          return appColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return appColors.primary.withOpacity(0.35);
          return appColors.outline.withOpacity(0.25);
        }),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: appColors.surface,
        contentTextStyle: TextStyle(color: appColors.onSurface),
        actionTextColor: appColors.primary,
      ),
    );

    return base;
  }
}
