// lib/ui/organisms/calendar/year/month_cell.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthCell extends StatelessWidget {
  final DateTime yearAnchor; // 1er janvier de l'année affichée
  final int month;           // 1..12
  final int? eventCount;
  final VoidCallback? onTap;
  const MonthCell({
    super.key,
    required this.yearAnchor,
    required this.month,
    this.eventCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime(yearAnchor.year, month, 1);
    final loc = Localizations.localeOf(context).toString();
    final monthName = DateFormat.MMMM(loc).format(date);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${monthName[0].toUpperCase()}${monthName.substring(1)}',
                    style: theme.textTheme.titleMedium),
                if ((eventCount ?? 0) > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: theme.colorScheme.primary.withOpacity(.12),
                    ),
                    child: Text('${eventCount!}', style: theme.textTheme.labelMedium),
                  ),
              ]),
              const Spacer(),
              Text('mini-cal', style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(.6),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
