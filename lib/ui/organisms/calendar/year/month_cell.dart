import 'package:flutter/material.dart';
import 'package:timora/ui/utils/date_utils.dart';

class MonthCell extends StatelessWidget {
  final DateTime yearAnchor;
  final int month;
  final int? eventCount;
  final VoidCallback? onTap;

  const MonthCell({
    super.key,
    required this.yearAnchor,
    required this.month,
    this.eventCount,
    this.onTap, String? calendarId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime(yearAnchor.year, month, 1);
    final monthName = formatMonthName(context, date); // 👈 appel util

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(monthName, style: theme.textTheme.titleMedium),
                  if ((eventCount ?? 0) > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: theme.colorScheme.primary.withOpacity(.12),
                      ),
                      child: Text('${eventCount!}', style: theme.textTheme.labelMedium),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                'mini-cal',
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
