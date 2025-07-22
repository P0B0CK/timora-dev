import 'package:flutter/material.dart';

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
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
          color: surfaceColor, // fond qui s'adapte au thème
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: primaryColor, // icône dans la couleur primaire
          size: size,
        ),
      ),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
