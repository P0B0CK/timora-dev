// FRONTEND
// lib/ui/atoms/icon_toggle.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timora/theme/theme_manager.dart';        // <- manager
import 'package:timora/theme/colors_extension.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    // rebuild uniquement quand le mode (dark/light) change
    final isDark = context.select<ThemeManager, bool>((m) => m.current.isDark);

    // tokens couleurs (fallback sur le colorScheme)
    final tokens = Theme.of(context).extension<AppColors>();
    final targetColor = tokens?.primary ?? Theme.of(context).colorScheme.primary;

    return TweenAnimationBuilder<Color?>(
      duration: const Duration(milliseconds: 220),
      tween: ColorTween(begin: targetColor, end: targetColor),
      builder: (context, animatedColor, child) {
        return IconButton(
          tooltip: 'Basculer thème clair/sombre',
          onPressed: () => context.read<ThemeManager>().toggleDuo(),
          iconSize: 24,
          splashRadius: 24,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (widget, animation) {
              final fade = FadeTransition(opacity: animation, child: widget);
              final scale = ScaleTransition(scale: Tween<double>(begin: 0.85, end: 1).animate(animation), child: fade);
              final rotate = RotationTransition(
                turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
                child: scale,
              );
              return rotate;
            },
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              key: ValueKey<bool>(isDark),
              color: animatedColor,
            ),
          ),
        );
      },
    );
  }
}
