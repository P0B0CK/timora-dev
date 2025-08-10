import 'package:flutter/material.dart';
import 'package:timora/theme/theme_tokens.dart';

enum ButtonType {
  primary,
  secondary,
  outlined,
}

/// Composant bouton Timora
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final ButtonType type;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelLarge;
    final tokens = theme.extension<TimoraTokens>()!;

    final disabled = isDisabled || isLoading;

    // 🎨 Attribution dynamique des couleurs selon le type
    late final Color bgColor;
    late final Color fgColor;
    BorderSide border = BorderSide.none;

    switch (type) {
      case ButtonType.primary:
        bgColor = tokens.primary;
        fgColor = tokens.textAuto; // texte lisible auto
        break;

      case ButtonType.secondary:
        bgColor = tokens.secondary;
        fgColor = tokens.textAuto; // lisible sur secondaire
        break;

      case ButtonType.outlined:
        bgColor = Colors.transparent;
        fgColor = tokens.primary;
        border = BorderSide(color: fgColor, width: 2);
        break;
    }

    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        elevation: (disabled || type == ButtonType.outlined) ? 0 : 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34),
          side: border,
        ),
        disabledBackgroundColor: bgColor.withOpacity(0.3),
        disabledForegroundColor: fgColor.withOpacity(0.6),
        textStyle: textStyle,
      ),
      child: isLoading
          ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      )
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          if (type == ButtonType.primary)
            Stack(
              children: [
                Text(
                  label,
                  style: textStyle?.copyWith(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = tokens.tertiary,
                  ),
                ),
                Text(
                  label,
                  style: textStyle?.copyWith(color: fgColor),
                ),
              ],
            )
          else
            Text(label),
        ],
      ),
    );
  }
}
