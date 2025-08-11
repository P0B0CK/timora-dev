// lib/theme/timora_theme.dart
import 'package:flutter/material.dart';
import 'colors_extension.dart';
import 'themes.dart';
import 'fonts.dart';

class TimoraTheme {
  static ThemeData build(ThemeModel model, {AppColors? override}) {
    final appColors = override ?? AppColors.fromThemeModel(model);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: appColors.primary,
      brightness: model.isDark ? Brightness.dark : Brightness.light,
      background: appColors.background,
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
      onSurface: appColors.onSurface,
      onBackground: appColors.onBackground,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: appColors.background,
      extensions: [appColors],
      textTheme: TextTheme(
        displayLarge: TimoraTextStyles.displayLarge.copyWith(color: appColors.onBackground),
        headlineMedium: TimoraTextStyles.headlineMedium.copyWith(color: appColors.onBackground),
        titleMedium: TimoraTextStyles.titleMedium.copyWith(color: appColors.onSurface),
        bodyLarge: TimoraTextStyles.bodyLarge.copyWith(color: appColors.onSurface),
        labelLarge: TimoraTextStyles.labelLarge.copyWith(color: appColors.onSurface),
      ),
      dividerTheme: DividerThemeData(
        color: appColors.divider,
        thickness: 1,
      ),
      cardTheme: CardThemeData( // <-- CardThemeData (pas CardTheme)
        color: appColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: appColors.outline),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return appColors.disabled;
            return appColors.primary;
          }),
          foregroundColor: MaterialStateProperty.all(appColors.onPrimary),
          overlayColor: MaterialStateProperty.all(appColors.primary.withOpacity(0.08)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: MaterialStateProperty.resolveWith((states) {
            return BorderSide(
              color: states.contains(MaterialState.disabled) ? appColors.disabled : appColors.outline,
            );
          }),
          foregroundColor: MaterialStateProperty.all(appColors.onSurface),
          overlayColor: MaterialStateProperty.all(appColors.focus.withOpacity(0.12)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(appColors.primary),
          overlayColor: MaterialStateProperty.all(appColors.primary.withOpacity(0.08)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return appColors.primary;
          return appColors.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return appColors.primary.withOpacity(0.35);
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
