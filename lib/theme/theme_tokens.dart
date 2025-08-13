// import 'package:flutter/material.dart';
//
// /// ===============================
// ///  ThemeExtension: TimoraTokens
// /// ===============================
// /// A SUPPRIMER :: OLD
// @immutable
// class TimoraTokens extends ThemeExtension<TimoraTokens> {
//   final Color bg;
//   final Color surface;
//   final Color surfaceAlt;
//
//   final Color primary;
//   final Color secondary;
//   final Color tertiary;
//
//   final Color textPrimary;
//   final Color textSecondary;
//   final Color textBrand;
//
//   final Color success;
//   final Color warning;
//   final Color error;
//
//   const TimoraTokens({
//     required this.bg,
//     required this.surface,
//     required this.surfaceAlt,
//     required this.primary,
//     required this.secondary,
//     required this.tertiary,
//     required this.textPrimary,
//     required this.textSecondary,
//     required this.textBrand,
//     required this.success,
//     required this.warning,
//     required this.error,
//   });
//
//   @override
//   TimoraTokens copyWith({
//     Color? bg,
//     Color? surface,
//     Color? surfaceAlt,
//     Color? primary,
//     Color? secondary,
//     Color? tertiary,
//     Color? textPrimary,
//     Color? textSecondary,
//     Color? textBrand,
//     Color? success,
//     Color? warning,
//     Color? error,
//   }) {
//     return TimoraTokens(
//       bg: bg ?? this.bg,
//       surface: surface ?? this.surface,
//       surfaceAlt: surfaceAlt ?? this.surfaceAlt,
//       primary: primary ?? this.primary,
//       secondary: secondary ?? this.secondary,
//       tertiary: tertiary ?? this.tertiary,
//       textPrimary: textPrimary ?? this.textPrimary,
//       textSecondary: textSecondary ?? this.textSecondary,
//       textBrand: textBrand ?? this.textBrand,
//       success: success ?? this.success,
//       warning: warning ?? this.warning,
//       error: error ?? this.error,
//     );
//   }
//
//   @override
//   TimoraTokens lerp(ThemeExtension<TimoraTokens>? other, double t) {
//     if (other is! TimoraTokens) return this;
//     return TimoraTokens(
//       bg: Color.lerp(bg, other.bg, t)!,
//       surface: Color.lerp(surface, other.surface, t)!,
//       surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
//       primary: Color.lerp(primary, other.primary, t)!,
//       secondary: Color.lerp(secondary, other.secondary, t)!,
//       tertiary: Color.lerp(tertiary, other.tertiary, t)!,
//       textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
//       textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
//       textBrand: Color.lerp(textBrand, other.textBrand, t)!,
//       success: Color.lerp(success, other.success, t)!,
//       warning: Color.lerp(warning, other.warning, t)!,
//       error: Color.lerp(error, other.error, t)!,
//     );
//   }
// }
