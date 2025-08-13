// icon.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timora/theme/colors_extension.dart';

enum AppIconStyle { alone, rounded }

class AppIcon extends StatefulWidget {
  /// Icône Flutter standard
  final IconData? icon;

  /// Icône SVG depuis les assets
  final String? assetName;

  /// Style visuel (icône seule ou pastille arrondie)
  final AppIconStyle style;

  /// Taille de l’icône (en px)
  final double size;

  /// Padding interne de la pastille (pour le style arrondi)
  final EdgeInsets padding;

  /// Infobulle affichée au survol/long press
  final String? tooltip;

  /// Callback au clic
  final VoidCallback? onPressed;

  /// Icône désactivée (opacité réduite, sans clic)
  final bool isDisabled;

  /// Animation de "push down" au clic
  final bool pushDown;

  /// Facteur d’échelle lors du "push down"
  final double pressedScale;

  const AppIcon({
    super.key,
    this.icon,
    this.assetName,
    this.style = AppIconStyle.alone,
    this.size = 24,
    this.padding = const EdgeInsets.all(6),
    this.tooltip,
    this.onPressed,
    this.isDisabled = false,
    this.pushDown = true,
    this.pressedScale = 0.96,
  }) : assert(
  icon != null || assetName != null,
  'Provide either `icon` (IconData) or `assetName` (SVG path).',
  );

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  double _scale = 1.0;

  void _onDown(TapDownDetails _) {
    if (!widget.pushDown || widget.isDisabled) return;
    setState(() => _scale = widget.pressedScale);
  }

  void _onUp(TapUpDetails _) {
    if (!widget.pushDown) return;
    setState(() => _scale = 1.0);
  }

  void _onCancel() {
    if (!widget.pushDown) return;
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppColors>();
    final scheme = theme.colorScheme;

    final primary = tokens?.primary ?? scheme.primary;
    final background = tokens?.background ?? scheme.background;

    final Color bgColor =
    widget.style == AppIconStyle.rounded ? primary : Colors.transparent;
    final Color iconColor =
    widget.style == AppIconStyle.rounded ? background : primary;

    final Widget iconWidget = widget.assetName != null
        ? SvgPicture.asset(
      widget.assetName!,
      width: widget.size,
      height: widget.size,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    )
        : Icon(widget.icon, size: widget.size, color: iconColor);

    Widget content;
    if (widget.style == AppIconStyle.rounded) {
      final resolved = widget.padding.resolve(Directionality.of(context));
      final double w = widget.size + resolved.horizontal;
      final double h = widget.size + resolved.vertical;
      final double dimRaw = w > h ? w : h;
      final double dim = math.max(48.0, dimRaw); // taille tactile min

      content = Container(
        width: dim,
        height: dim,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: iconWidget,
      );
    } else {
      content = iconWidget;
    }

    final scaled = AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOutCubic,
      child: Opacity(
        opacity: widget.isDisabled ? 0.6 : 1.0,
        child: content,
      ),
    );

    final wrapped = GestureDetector(
      onTapDown: _onDown,
      onTapUp: _onUp,
      onTapCancel: _onCancel,
      onTap: widget.onPressed == null
          ? null
          : () {
        HapticFeedback.lightImpact();
        widget.onPressed!();
      },
      behavior: HitTestBehavior.deferToChild,
      child: scaled,
    );

    return Semantics(
      button: widget.onPressed != null,
      enabled: !widget.isDisabled,
      label: widget.tooltip,
      child: widget.tooltip != null && widget.tooltip!.isNotEmpty
          ? Tooltip(message: widget.tooltip!, child: wrapped)
          : wrapped,
    );
  }
}
