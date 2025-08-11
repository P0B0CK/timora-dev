import 'package:flutter/material.dart';
/// A SUPPRIMER :: OLD
class PrimaryIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onPressed;
  final String? tooltip;

  const PrimaryIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return IconButton(
      icon: Icon(icon, color: primaryColor, size: size),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
