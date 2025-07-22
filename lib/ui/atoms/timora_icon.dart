import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/timora_colors.dart';

class TimoraIcon extends StatelessWidget {
  final String iconPath; // ← chemin vers l'icône SVG (ex: assets/icons/settings.svg)
  final double size;
  final Color? color;
  final bool rounded;

  const TimoraIcon({
    super.key,
    required this.iconPath,
    this.size = 42,
    this.color,
  }) : rounded = false;

  const TimoraIcon.rounded({
    super.key,
    required this.iconPath,
    this.size = 42,
  })  : color = null,
        rounded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<TimoraColors>();

    final iconColor = rounded
        ? colors?.iconColor ?? theme.colorScheme.primary
        : (color ?? theme.colorScheme.primary);

    final backgroundColor = colors?.roundedBackground
        ?? theme.colorScheme.surface;

    final iconWidget = SvgPicture.asset(
      iconPath,
      width: size * 0.75,
      height: size * 0.75,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );

    if (!rounded) return iconWidget;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: iconWidget,
    );
  }
}
