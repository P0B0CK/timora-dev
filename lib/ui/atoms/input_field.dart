// lib/ui/atoms/input_field.dart
import 'package:flutter/material.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/theme/fonts.dart';
import 'package:timora/ui/atoms/alert_message.dart';
import 'package:timora/theme/colors.dart';

enum InputStatus { normal, error, success, warning, info }

class CustomInputField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;

  final InputStatus status;
  final String? message;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  /// Hauteur FIXE du champ
  final double height;

  /// Padding interne (aération)
  final EdgeInsetsGeometry contentPadding;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.status = InputStatus.normal,
    this.message,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.height = 56,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late final FocusNode _focusNode;
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(() => setState(() {}));
    _obscure = widget.isPassword;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color _statusColor(BuildContext context) {
    final tokens = Theme.of(context).extension<AppColors>()!;
    switch (widget.status) {
      case InputStatus.error:   return tokens.error;
      case InputStatus.warning: return tokens.warning;
      case InputStatus.success: return tokens.success;
      case InputStatus.info:    return tokens.info;
      case InputStatus.normal:  return Colors.white; // bordure au repos
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final tokens  = theme.extension<AppColors>()!;
    final scheme  = theme.colorScheme;

    final focused  = _focusNode.hasFocus;
    final disabled = !widget.enabled;

    final pageBg  = theme.scaffoldBackgroundColor;
    final onSurf  = tokens.onSurface;
    final primary = tokens.primary;

    // Bordure : statut > focus > blanc
    final statusColor = _statusColor(context);
    final hasStatus   = widget.status != InputStatus.normal;
    final borderColor = hasStatus ? statusColor : (focused ? primary : Colors.white);
    final borderWidth = hasStatus ? 2.0 : (focused ? 2.0 : 1.2);

    // Label (avec contour), fond identique à la page
    const double labelHeight = 22;
    final labelStyle = TimoraTextStyles.labelLarge.copyWith(
      color: hasStatus ? statusColor : (focused ? primary : onSurf),
      fontSize: 12.5,
      height: 1.0,
    );

    // Padding effectif (réserve une place pour l’icône œil si besoin)
    final resolved = widget.contentPadding.resolve(Directionality.of(context));
    final double rightExtra = widget.isPassword ? 40.0 : 0.0;
    final EdgeInsets effectivePadding = EdgeInsets.fromLTRB(
      resolved.left, resolved.top, resolved.right + rightExtra, resolved.bottom,
    );

    // Conteneur principal — transparent — hauteur fixe
    final field = AnimatedContainer(
      width: double.infinity,
      height: widget.height,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Stack(
        children: [
          // TextField occupe tout — hint natif, donc il disparaît quand on tape
          Positioned.fill(
            child: Padding(
              padding: effectivePadding,
              child: Center(
                child: Theme(
                  data: theme.copyWith(
                    // neutralise splash/hover/outline autour du TextField
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    keyboardType: widget.keyboardType,
                    obscureText: _obscure,
                    minLines: 1,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: disabled ? onSurf.withOpacity(0.6) : onSurf,
                    ),
                    cursorColor: hasStatus ? statusColor : primary,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: widget.hint, // <= hint natif
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: onSurf.withOpacity(0.55),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Suffix œil — superposé à droite
          if (widget.isPassword)
            Positioned(
              right: 8, top: 0, bottom: 0,
              child: Center(
                child: IconButton(
                  tooltip: _obscure ? 'Afficher' : 'Masquer',
                  onPressed: disabled ? null : () => setState(() => _obscure = !_obscure),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  icon: Icon(
                    _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    size: 20,
                    color: (hasStatus ? statusColor : (focused ? primary : onSurf.withOpacity(0.7))),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    // Badge label (contour + fond = page)
    final badge = Positioned(
      left: 16,
      top: -(labelHeight / 2) + (borderWidth / 2),
      child: Container(
        height: labelHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: pageBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Text(widget.label, style: labelStyle),
      ),
    );

    // Message sous le champ
    final showMsg = (widget.message?.isNotEmpty ?? false);
    final msgType = switch (widget.status) {
      InputStatus.error   => AlertType.error,
      InputStatus.warning => AlertType.warning,
      InputStatus.success => AlertType.success,
      InputStatus.info    => AlertType.info,
      _ => null,
    };

    return Semantics(
      textField: true,
      enabled: widget.enabled,
      label: widget.label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              field,
              badge,
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: showMsg && msgType != null
                ? Padding(
              key: ValueKey(widget.message),
              padding: const EdgeInsets.only(top: 10),
              child: AppAlertMessage(
                message: widget.message!,
                type: msgType!,
                dense: true,
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
