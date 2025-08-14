// lib/ui/organisms/calendar/year/year_grid.dart
import 'package:flutter/material.dart';
import 'month_cell.dart';

class YearGrid extends StatelessWidget {
  final DateTime year;
  final Map<int, int>? eventsPerMonth; // {month: count}
  final void Function(int month)? onMonthTap;
  const YearGrid({
    super.key,
    required this.year,
    this.eventsPerMonth,
    this.onMonthTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.2,
      ),
      itemCount: 12,
      itemBuilder: (_, i) {
        final m = i + 1;
        return MonthCell(
          yearAnchor: year,
          month: m,
          eventCount: eventsPerMonth?[m],
          onTap: onMonthTap == null ? null : () => onMonthTap!(m),
        );
      },
    );
  }
}
