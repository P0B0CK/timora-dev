import 'package:flutter/material.dart';
import 'package:timora/ui/organisms/calendar/year/month_cell.dart';

class YearGrid extends StatelessWidget {
  final DateTime year;
  final Map<int, int>? eventsPerMonth; // {month: count}
  final void Function(int month)? onMonthTap;

  // 👇 ajoute calendarId
  final String? calendarId;

  const YearGrid({
    super.key,
    required this.year,
    this.eventsPerMonth,
    this.onMonthTap,
    this.calendarId, // 👈 ajouté
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: 12,
      itemBuilder: (_, i) {
        final m = i + 1;
        return MonthCell(
          yearAnchor: year,
          month: m,
          eventCount: eventsPerMonth?[m],
          onTap: onMonthTap == null ? null : () => onMonthTap!(m),
          calendarId: calendarId, // 👈 propagé
        );
      },
    );
  }
}
