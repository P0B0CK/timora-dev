// lib/ui/molecules/event_list_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListItem extends StatelessWidget {
  final String title;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? location;
  final String? notes;

  const EventListItem({
    super.key,
    required this.title,
    this.startsAt,
    this.endsAt,
    this.location,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = Localizations.localeOf(context).toString();
    final fmt = DateFormat('EEE d MMM • HH:mm', loc);

    String subtitle = '';
    if (startsAt != null) {
      subtitle = fmt.format(startsAt!);
      if (endsAt != null) {
        subtitle += ' → ${DateFormat('HH:mm', loc).format(endsAt!)}';
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.event, size: 22, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.75)),
                ),
              if (location != null && location!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(location!, style: theme.textTheme.bodySmall),
                ),
              if (notes != null && notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    notes!,
                    style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
