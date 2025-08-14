// lib/theme/app_colors_extension.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'themes.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  // Couleurs de base
  final Color background;
  final Color surface;
  final Color onBackground;
  final Color onSurface;

  // Actions / Accents
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color onTertiary;

  // États
  final Color disabled;
  final Color onDisabled;
  final Color divider;
  final Color outline;
  final Color focus;

  // Feedback
  final Color success;
  final Color error;
  final Color warning;
  final Color info;

  const AppColors({
    required this.background,
    required this.surface,
    required this.onBackground,
    required this.onSurface,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.disabled,
    required this.onDisabled,
    required this.divider,
    required this.outline,
    required this.focus,
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
  });

  /// Mapping light/dark :
  static AppColors fromThemeModel(ThemeModel theme) {
    final p = theme.palette;
    final fb = theme.feedback;

    if (theme.isDark) {
      return AppColors(
        background: p.backgroundColor,
        surface: Color.alphaBlend(Colors.white.withOpacity(0.03), p.backgroundColor),
        onBackground: p.textColorWhite,
        onSurface: p.textColorWhite.withOpacity(0.92),
        primary: p.primaryColor,
        onPrimary: p.textColorBlack,
        secondary: p.secondaryColor,
        onSecondary: p.textColorWhite,
        tertiary: p.tertiaryColor,
        onTertiary: p.textColorBlack,
        disabled: Colors.white.withOpacity(0.28),
        onDisabled: Colors.black.withOpacity(0.40),
        divider: Colors.white.withOpacity(0.12),
        outline: Colors.white.withOpacity(0.25),
        focus: p.primaryColor.withOpacity(0.5),
        success: fb.success,
        error: fb.error,
        warning: fb.warning,
        info: fb.info,
      );
    } else {
      // Light: fonds clairs, texte sombre
      return AppColors(
        background: Colors.white,
        surface: const Color(0xFFF8F8F9),
        onBackground: p.textColorBlack,
        onSurface: const Color(0xFF1A1A1A),
        primary: p.primaryColor,
        onPrimary: p.textColorBlack,
        secondary: p.secondaryColor,
        onSecondary: p.textColorWhite,
        tertiary: p.tertiaryColor,
        onTertiary: p.textColorBlack,
        disabled: Colors.black.withOpacity(0.24),
        onDisabled: Colors.white.withOpacity(0.65),
        divider: Colors.black.withOpacity(0.08),
        outline: Colors.black.withOpacity(0.14),
        focus: p.primaryColor.withOpacity(0.35),
        success: fb.success,
        error: fb.error,
        warning: fb.warning,
        info: fb.info,
      );
    }
  }

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? onBackground,
    Color? onSurface,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? tertiary,
    Color? onTertiary,
    Color? disabled,
    Color? onDisabled,
    Color? divider,
    Color? outline,
    Color? focus,
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      disabled: disabled ?? this.disabled,
      onDisabled: onDisabled ?? this.onDisabled,
      divider: divider ?? this.divider,
      outline: outline ?? this.outline,
      focus: focus ?? this.focus,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color _lerp(Color a, Color b) => Color.lerp(a, b, t)!;

    return AppColors(
      background: _lerp(background, other.background),
      surface: _lerp(surface, other.surface),
      onBackground: _lerp(onBackground, other.onBackground),
      onSurface: _lerp(onSurface, other.onSurface),
      primary: _lerp(primary, other.primary),
      onPrimary: _lerp(onPrimary, other.onPrimary),
      secondary: _lerp(secondary, other.secondary),
      onSecondary: _lerp(onSecondary, other.onSecondary),
      tertiary: _lerp(tertiary, other.tertiary),
      onTertiary: _lerp(onTertiary, other.onTertiary),
      disabled: _lerp(disabled, other.disabled),
      onDisabled: _lerp(onDisabled, other.onDisabled),
      divider: _lerp(divider, other.divider),
      outline: _lerp(outline, other.outline),
      focus: _lerp(focus, other.focus),
      success: _lerp(success, other.success),
      error: _lerp(error, other.error),
      warning: _lerp(warning, other.warning),
      info: _lerp(info, other.info),
    );
  }
}
