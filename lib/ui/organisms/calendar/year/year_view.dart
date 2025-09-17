import 'package:flutter/material.dart';
import 'package:timora/services/events_service.dart';
import 'package:timora/ui/organisms/calendar/year/year_grid.dart';
import 'package:timora/ui/organisms/calendar/month/month_modal.dart';

class YearView extends StatefulWidget {
  final String calendarId;
  final DateTime year; // tip: DateTime(year, 1, 1)

  const YearView({
    super.key,
    required this.calendarId,
    required this.year,
  });

  @override
  State<YearView> createState() => _YearViewState();
}

class _YearViewState extends State<YearView> {
  final _events = EventsService();
  late Future<Map<int, int>> _future;

  @override
  void initState() {
    super.initState();
    _future = _events.countByMonth(
      calendarId: widget.calendarId,
      year: widget.year.year,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _events.countByMonth(
        calendarId: widget.calendarId,
        year: widget.year.year,
      );
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, int>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Erreur: ${snap.error}'),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _refresh,
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        final counts = snap.data ?? const <int, int>{};

        return RefreshIndicator(
          onRefresh: _refresh,
          child: YearGrid(
            year: widget.year,
            eventsPerMonth: counts,            // ← alimente les pastilles du YearGrid
            calendarId: widget.calendarId,     // ← pour ouvrir la modale depuis MonthCell
            onMonthTap: (m) async {
              await showMonthModal(
                context: context,
                calendarId: widget.calendarId,
                yearAnchor: DateTime(widget.year.year, 1, 1),
                month: m,
              );
              // après fermeture : refresh pour refléter une création d’event
              await _refresh();
            },
          ),
        );
      },
    );
  }
}
