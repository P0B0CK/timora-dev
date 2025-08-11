import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/theme/fonts.dart';

enum ButtonType { primary, secondary, outlined }

class AppButton extends StatefulWidget {
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() => _scale = 0.96);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppColors>();
    final scheme = theme.colorScheme;

    final disabled = widget.isDisabled || widget.isLoading;

    late final Color bgColor;
    late final Color fgColor;
    BorderSide border = BorderSide.none;
    TextStyle textStyle;

    switch (widget.type) {
      case ButtonType.primary:
        bgColor = tokens?.primary ?? scheme.primary;
        fgColor = tokens?.onPrimary ?? scheme.onPrimary;
        textStyle = TimoraTextStyles.labelLarge.copyWith(color: fgColor);
        break;
      case ButtonType.secondary:
        bgColor = tokens?.secondary ?? scheme.secondary;
        fgColor = tokens?.onSecondary ?? scheme.onSecondary;
        textStyle = TimoraTextStyles.labelLarge.copyWith(color: fgColor);
        break;
      case ButtonType.outlined:
        bgColor = Colors.transparent;
        fgColor = tokens?.primary ?? scheme.primary;
        border = BorderSide(color: fgColor, width: 2);
        textStyle = theme.textTheme.labelLarge!.copyWith(color: fgColor);
        break;
    }

    final child = widget.isLoading
        ? LoadingAnimationWidget.inkDrop(
      color: fgColor,
      size: 22,
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 20, color: fgColor),
          const SizedBox(width: 8),
        ],
        Text(widget.label, style: textStyle),
      ],
    );

    final container = Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
        border: border == BorderSide.none
            ? null
            : Border.all(color: border.color, width: border.width),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: child,
    );

    final scaled = AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Opacity(
        opacity: widget.isDisabled ? 0.6 : 1.0,
        child: container,
      ),
    );

    final gesture = GestureDetector(
      onTapDown: disabled ? null : _onTapDown,
      onTapUp: disabled ? null : _onTapUp,
      onTapCancel: disabled ? null : _onTapCancel,
      onTap: disabled
          ? null
          : () {
        HapticFeedback.lightImpact();
        widget.onPressed();
      },
      child: scaled,
    );

    // Accessibilité
    return Semantics(
      button: true,
      enabled: !disabled,
      label: widget.label,
      value: widget.isLoading ? 'Chargement' : null,
      child: gesture,
    );
  }
}
