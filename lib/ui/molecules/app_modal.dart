// lib/ui/molecules/app_modal.dart
import 'package:flutter/material.dart';
import 'package:timora/ui/atoms/button.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/theme/fonts_extension.dart';

class AppModalAction<T> {
  final String label;
  final ButtonType type;
  final T? result;
  final bool isDisabled;
  final bool isLoading;

  const AppModalAction({
    required this.label,
    required this.type,
    this.result,
    this.isDisabled = false,
    this.isLoading = false,
  });
}

Future<T?> showAppModal<T>({
  required BuildContext context,
  required String title,
  String? message,
  Widget? content,
  List<AppModalAction<T>> actions = const [],
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  Color? barrierColor,
  double gapTitleToContent = 24.0,
  double gapContentToActions = 24.0,
}) {
  assert(message != null || content != null, 'Provide either `message` or a custom `content`.');

  final theme = Theme.of(context);
  final defaultBarrier = (theme.brightness == Brightness.dark)
      ? Colors.black.withOpacity(0.65)
      : Colors.black54;

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    barrierColor: barrierColor ?? defaultBarrier,
    builder: (ctx) => _AppModalCard<T>(
      title: title,
      message: message,
      content: content,
      actions: actions,
      useRootNavigator: useRootNavigator,
      gapTitleToContent: gapTitleToContent,
      gapContentToActions: gapContentToActions,
    ),
  );
}

Future<bool?> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirmer',
  String cancelLabel = 'Annuler',
  ButtonType confirmType = ButtonType.primary,
  ButtonType cancelType = ButtonType.outlined,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  double gapTitleToContent = 22.0,
  double gapContentToActions = 28.0,
}) {
  return showAppModal<bool>(
    context: context,
    title: title,
    message: message,
    actions: [
      AppModalAction<bool>(label: cancelLabel, type: cancelType, result: false),
      AppModalAction<bool>(label: confirmLabel, type: confirmType, result: true),
    ],
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    gapTitleToContent: gapTitleToContent,
    gapContentToActions: gapContentToActions,
  );
}

class _AppModalCard<T> extends StatefulWidget {
  final String title;
  final String? message;
  final Widget? content;
  final List<AppModalAction<T>> actions;
  final bool useRootNavigator;
  final double gapTitleToContent;
  final double gapContentToActions;

  const _AppModalCard({
    required this.title,
    this.message,
    this.content,
    required this.actions,
    required this.useRootNavigator,
    this.gapTitleToContent = 22.0,
    this.gapContentToActions = 28.0,
  });

  @override
  State<_AppModalCard<T>> createState() => _AppModalCardState<T>();
}

class _AppModalCardState<T> extends State<_AppModalCard<T>> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.985;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() { _opacity = 1.0; _scale = 1.0; });
    });
  }

  double _scaledGap(double base, double textScale) {
    final s = textScale.clamp(1.0, 1.6);
    return base * (0.95 + (s - 1.0) * 0.5);
  }

  @override
  Widget build(BuildContext context) {
    final theme    = Theme.of(context);
    final tokens   = theme.extension<AppColors>();
    final extra    = theme.extension<TimoraExtraTextStyles>();
    final media    = MediaQuery.of(context);
    final shortest = media.size.shortestSide;

    final cardWidth = (shortest * 0.72).clamp(320.0, 520.0).toDouble();

    // Style
    final Color surface   = tokens?.surface ?? theme.colorScheme.surface;
    final Color outline   = tokens?.outline ?? theme.dividerColor;
    final Color onSurface = tokens?.onSurface ?? theme.colorScheme.onSurface;

    final BoxShadow softShadow = BoxShadow(
      color: (theme.brightness == Brightness.dark) ? Colors.black.withOpacity(0.45) : Colors.black.withOpacity(0.08),
      blurRadius: 30,
      offset: const Offset(0, 18),
    );

    // PADDINGS
    const vPad = 32.0;
    const hPad = 24.0;

    // Ouverture du clavier tactile
    final bottomInset      = media.viewInsets.bottom;
    final keyboardOpen     = bottomInset > 0;
    final double safeGap   = 28.0;
    final double outerPad  = keyboardOpen ? (bottomInset + 16.0) : safeGap;
    final double maxCardHeight = (media.size.height - outerPad - safeGap).clamp(280.0, media.size.height);

    final double gapTop    = _scaledGap(widget.gapTitleToContent,  media.textScaleFactor);
    final double gapBottom = _scaledGap(widget.gapContentToActions, media.textScaleFactor);

    final titleWidget = Text(
      widget.title,
      style: extra?.titleBrand ?? theme.textTheme.headlineMedium,
    );

    final contentWidget = widget.content ?? Text(
      widget.message ?? '',
      style: theme.textTheme.bodyLarge?.copyWith(color: onSurface.withOpacity(0.92)),
    );

    final actionsWrap = Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.end,
        children: [
          for (final a in widget.actions)
            AppButton(
              label: a.label,
              type: a.type,
              isLoading: a.isLoading,
              isDisabled: a.isDisabled,
              onPressed: () => Navigator.of(context, rootNavigator: widget.useRootNavigator).pop(a.result),
            ),
        ],
      ),
    );

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: outline, width: 1.2),
        boxShadow: [softShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: cardWidth,
            maxWidth: cardWidth,
            maxHeight: maxCardHeight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              SizedBox(height: gapTop),
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: contentWidget,
                ),
              ),
              SizedBox(height: gapBottom),
              actionsWrap,
            ],
          ),
        ),
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(bottom: outerPad),
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              opacity: _opacity,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                scale: _scale,
                child: card,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
