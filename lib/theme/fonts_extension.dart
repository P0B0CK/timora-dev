import 'package:flutter/material.dart';
import 'fonts.dart';

@immutable
class TimoraExtraTextStyles extends ThemeExtension<TimoraExtraTextStyles> {
  final TextStyle titleBrand;

  final TextStyle headlineBrand;

  final TextStyle labelBold;

  const TimoraExtraTextStyles({
    required this.titleBrand,
    required this.headlineBrand,
    required this.labelBold,
  });

  factory TimoraExtraTextStyles.fromColors({
    required Color primary,
    required Color onSurface,
  }) {
    return TimoraExtraTextStyles(
      titleBrand: TimoraTextStyles.titleMedium.copyWith(color: primary),
      headlineBrand: TimoraTextStyles.headlineMedium.copyWith(color: primary),
      labelBold: TimoraTextStyles.labelBold.copyWith(color: onSurface),
    );
  }

  @override
  TimoraExtraTextStyles copyWith({
    TextStyle? titleBrand,
    TextStyle? headlineBrand,
    TextStyle? labelBold,
  }) {
    return TimoraExtraTextStyles(
      titleBrand: titleBrand ?? this.titleBrand,
      headlineBrand: headlineBrand ?? this.headlineBrand,
      labelBold: labelBold ?? this.labelBold,
    );
  }

  @override
  TimoraExtraTextStyles lerp(ThemeExtension<TimoraExtraTextStyles>? other, double t) {
    if (other is! TimoraExtraTextStyles) return this;
    return TimoraExtraTextStyles(
      titleBrand: TextStyle.lerp(titleBrand, other.titleBrand, t) ?? titleBrand,
      headlineBrand: TextStyle.lerp(headlineBrand, other.headlineBrand, t) ?? headlineBrand,
      labelBold: TextStyle.lerp(labelBold, other.labelBold, t) ?? labelBold,
    );
  }
}
