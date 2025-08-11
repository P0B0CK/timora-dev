// lib/ui/atoms/alert_message.dart
import 'package:flutter/material.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/theme/colors.dart';

enum AlertType { error, warning, success, info }

class AppAlertMessage extends StatelessWidget {
  final String message;
  final AlertType type;
  final bool dense;
  final VoidCallback? onClose;

  const AppAlertMessage({
    super.key,
    required this.message,
    required this.type,
    this.dense = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();
    final scheme = theme.colorScheme;

    final Color accent = switch (type) {
      AlertType.error   => (tokens?.error   ?? defaultFeedback.error),
      AlertType.warning => (tokens?.warning ?? defaultFeedback.warning),
      AlertType.success => (tokens?.success ?? defaultFeedback.success),
      AlertType.info    => (tokens?.info    ?? defaultFeedback.info),
    };

    final Color surface = tokens?.surface ?? scheme.surface;
    final Color textColor = tokens?.onSurface ?? scheme.onSurface;
    final Color bg = Color.alphaBlend(accent.withOpacity(0.12), surface.withOpacity(0.6));

    final content = Row(
      children: [
        Icon(_iconFor(type), color: accent, size: dense ? 18 : 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        ),
        if (onClose != null) ...[
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Fermer',
            onPressed: onClose,
            icon: Icon(Icons.close_rounded, color: textColor.withOpacity(0.7), size: dense ? 18 : 20),
          ),
        ],
      ],
    );

    return Semantics(
      label: 'Alerte ${type.name}',
      liveRegion: true,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: accent, width: 1.2),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: dense ? 8 : 12,
        ),
        child: content,
      ),
    );
  }

  IconData _iconFor(AlertType t) {
    switch (t) {
      case AlertType.error:   return Icons.error_rounded;
      case AlertType.warning: return Icons.warning_rounded;
      case AlertType.success: return Icons.check_circle_rounded;
      case AlertType.info:    return Icons.info_rounded;
    }
  }
}
