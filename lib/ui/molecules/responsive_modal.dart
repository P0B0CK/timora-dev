import 'package:flutter/material.dart';
import 'package:timora/ui/atoms/button.dart' show ButtonType, AppButton;
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/theme/fonts_extension.dart';

class ResponsiveModalAction<T> {
  final String label;
  final ButtonType type;
  final T? result;
  final bool isDisabled;
  final bool isLoading;

  const ResponsiveModalAction({
    required this.label,
    required this.type,
    this.result,
    this.isDisabled = false,
    this.isLoading = false,
  });
}

Future<T?> showResponsiveModal<T>({
  required BuildContext context,
  required String title,
  String? message,
  Widget? content,
  List<ResponsiveModalAction<T>> actions = const [],
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  bool withShadow = true, // 👈 paramètre clé
  Color? barrierColor,
}) {
  final theme = Theme.of(context);
  final defaultBarrier = (theme.brightness == Brightness.dark)
      ? Colors.black.withOpacity(0.65)
      : Colors.black54;

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    barrierColor: barrierColor ?? defaultBarrier,
    builder: (_) => _ResponsiveModalCard<T>(
      title: title,
      message: message,
      content: content,
      actions: actions,
      useRootNavigator: useRootNavigator,
      withShadow: withShadow,
    ),
  );
}

class _ResponsiveModalCard<T> extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final List<ResponsiveModalAction<T>> actions;
  final bool useRootNavigator;
  final bool withShadow;

  const _ResponsiveModalCard({
    required this.title,
    this.message,
    this.content,
    required this.actions,
    required this.useRootNavigator,
    required this.withShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme    = Theme.of(context);
    final tokens   = theme.extension<AppColors>();
    final extra    = theme.extension<TimoraExtraTextStyles>();
    final media    = MediaQuery.of(context);

    final surface   = tokens?.surface ?? theme.colorScheme.surface;
    final outline   = tokens?.outline ?? theme.dividerColor;
    final onSurface = tokens?.onSurface ?? theme.colorScheme.onSurface;

    final boxShadow = withShadow
        ? [
      BoxShadow(
        color: (theme.brightness == Brightness.dark)
            ? Colors.black.withOpacity(0.45)
            : Colors.black.withOpacity(0.08),
        blurRadius: 30,
        offset: const Offset(0, 18),
      ),
    ]
        : const <BoxShadow>[]; // 👈 pas d’ombre si withShadow = false

    final titleWidget = Text(
      title,
      style: extra?.titleBrand ?? theme.textTheme.headlineMedium,
    );

    final body = content ??
        Text(
          message ?? '',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: onSurface.withOpacity(0.92),
          ),
        );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: media.size.width < 600 ? media.size.width * 0.9 : 520,
          maxHeight: media.size.height * 0.9,
        ),
        child: Material(
          color: Colors.transparent,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: outline, width: 1.2),
              boxShadow: boxShadow, // 👈 dépend du paramètre
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(alignment: Alignment.centerLeft, child: titleWidget),
                  const SizedBox(height: 22),
                  Flexible(
                    fit: FlexFit.loose,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: body,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.end,
                      children: [
                        for (final a in actions)
                          AppButton(
                            label: a.label,
                            type: a.type,
                            isLoading: a.isLoading,
                            isDisabled: a.isDisabled,
                            onPressed: () => Navigator.of(
                              context,
                              rootNavigator: useRootNavigator,
                            ).pop(a.result),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
