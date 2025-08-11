// lib/ui/atoms/rounded_icon.dart
///// A SUPPRIMER :: OLD
import 'package:flutter/material.dart';
import 'package:timora/theme/theme_tokens.dart';

class RoundedIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onPressed;
  final String? tooltip;

  const RoundedIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<TimoraTokens>();

    // brightness pour savoir si on est en dark/light
    final isDark = theme.brightness == Brightness.dark;

    // 🎨 Règle:
    // - Dark: bg = primary (vert fluo), icon = secondary (violet myth)
    // - Light: bg = primary (violet myth), icon = tertiary (vert fluo)
    final Color bgColor = tokens?.primary ?? theme.colorScheme.primary;
    final Color iconColor = isDark
        ? (tokens?.secondary ?? theme.colorScheme.secondary)
        : (tokens?.tertiary ?? theme.colorScheme.tertiary);

    // état visuel disabled
    final bool disabled = onPressed == null;
    final double opacity = disabled ? 0.5 : 1.0;

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        // assure une cible tactile confortable
        minimumSize: const Size(40, 40),
        padding: EdgeInsets.zero,
      ),
      icon: Opacity(
        opacity: opacity,
        child: Container(
          width: size + 16,  // 8px de padding interne tout autour
          height: size + 16,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: iconColor,
            size: size,
          ),
        ),
      ),
    );
  }
}
