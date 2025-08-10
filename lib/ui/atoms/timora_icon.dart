// FRONTEND
// lib/ui/atoms/timora_icon.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timora/theme/theme_tokens.dart';

/// Icône personnalisée Timora (avec ou sans fond circulaire)
class TimoraIcon extends StatelessWidget {
  final String iconPath; // 🖼️ Chemin vers le fichier SVG
  final double size;     // 📏 Taille totale
  final Color? color;    // 🎨 Couleur custom (si définie, prioritaire)
  final bool rounded;    // ⭕ Icône avec fond circulaire
  final String? semanticsLabel;

  /// Icône simple (pas entourée)
  const TimoraIcon({
    super.key,
    required this.iconPath,
    this.size = 42,
    this.color,
    this.semanticsLabel,
  }) : rounded = false;

  /// Icône entourée (circulaire)
  const TimoraIcon.rounded({
    super.key,
    required this.iconPath,
    this.size = 42,
    this.semanticsLabel,
  })  : color = null,
        rounded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<TimoraTokens>();

    // 🎯 Couleur de l'icône
    // - si `color` fourni → prioritaire
    // - sinon, si rounded → on choisit une couleur lisible sur le fond (calculé plus bas)
    // - sinon → accent primaire
    Color iconColor;
    // 🟣 Couleur de fond si entourée
    final Color bgColor =
        tokens?.tertiary ?? theme.colorScheme.surfaceVariant;

    if (color != null) {
      iconColor = color!;
    } else if (rounded) {
      // auto on-color pour lisibilité
      iconColor = _autoOn(bgColor);
    } else {
      iconColor = tokens?.primary ?? theme.colorScheme.primary;
    }

    final iconWidget = SvgPicture.asset(
      iconPath,
      width: size * 0.75,
      height: size * 0.75,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      semanticsLabel: semanticsLabel,
    );

    // Icône simple (sans fond)
    if (!rounded) return iconWidget;

    // Icône entourée (fond circulaire)
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: iconWidget,
    );
  }
}

Color _autoOn(Color bg) =>
    bg.computeLuminance() > 0.5 ? const Color(0xDD000000) : Colors.white;
