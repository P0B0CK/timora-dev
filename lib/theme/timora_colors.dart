import 'package:flutter/material.dart';

@immutable
class TimoraColors extends ThemeExtension<TimoraColors> {
  final Color roundedBackground;
  final Color iconColor;
  final Color toggleTrackActive;
  final Color toggleThumbActive;
  final Color toggleTrackInactive;
  final Color toggleThumbInactive;
  final Color toggleOutlineInactive;


  const TimoraColors({
    required this.roundedBackground,
    required this.iconColor,
    required this.toggleTrackActive,
    required this.toggleThumbActive,
    required this.toggleTrackInactive,
    required this.toggleThumbInactive,
    required this.toggleOutlineInactive,
  });

  @override
  TimoraColors copyWith({
    Color? roundedBackground,
    Color? iconColor,
    Color? toggleTrackActive,
    Color? toggleThumbActive,
    Color? toggleTrackInactive,
    Color? toggleThumbInactive,
    Color? toggleOutlineInactive,
  }) {
    return TimoraColors(
      roundedBackground: roundedBackground ?? this.roundedBackground,
      iconColor: iconColor ?? this.iconColor,
      toggleTrackActive: toggleTrackActive ?? this.toggleTrackActive,
      toggleThumbActive: toggleThumbActive ?? this.toggleThumbActive,
      toggleTrackInactive: toggleTrackInactive ?? this.toggleTrackInactive,
      toggleThumbInactive: toggleThumbInactive ?? this.toggleThumbInactive,
      toggleOutlineInactive: toggleOutlineInactive ?? this.toggleOutlineInactive,
    );
  }

  @override
  TimoraColors lerp(ThemeExtension<TimoraColors>? other, double t) {
    if (other is! TimoraColors) return this;
    return TimoraColors(
      roundedBackground: Color.lerp(roundedBackground, other.roundedBackground, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      toggleTrackActive: Color.lerp(toggleTrackActive, other.toggleTrackActive, t)!,
      toggleThumbActive: Color.lerp(toggleThumbActive, other.toggleThumbActive, t)!,
      toggleTrackInactive: Color.lerp(toggleTrackInactive, other.toggleTrackInactive, t)!,
      toggleThumbInactive: Color.lerp(toggleThumbInactive, other.toggleThumbInactive, t)!,
      toggleOutlineInactive: Color.lerp(toggleOutlineInactive, other.toggleOutlineInactive, t)!,
    );
  }
}
