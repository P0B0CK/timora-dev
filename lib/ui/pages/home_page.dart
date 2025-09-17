import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timora/services/calendar_service.dart';
import 'package:timora/services/events_service.dart';
import 'package:timora/ui/atoms/breadcrumb/breadcrumb_atom.dart';
import 'package:timora/ui/atoms/breadcrumb/breadcrumb_item.dart';
import 'package:timora/ui/organisms/calendar/year/year_grid.dart';
import 'package:timora/ui/organisms/calendar/month/month_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.onPrev,
    this.onNext,
    this.onProfile,
  });

  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onProfile;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _calSrv = CalendarService();
  final _evtSrv = EventsService();

  String? _calendarId;
  Map<int, int> _eventsPerMonth = {};
  late DateTime _yearAnchor;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _yearAnchor = DateTime(now.year, 1, 1);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw 'Utilisateur non connecté';
      final calId = await _calSrv.getPersonalCalendarId(uid);
      if (calId == null) throw 'Aucun agenda personnel trouvé';
      final counts = await _evtSrv.countByMonth(
        calendarId: calId,
        year: _yearAnchor.year,
      );
      if (!mounted) return;
      setState(() {
        _calendarId = calId;
        _eventsPerMonth = counts;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _reloadYearCounts() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final calId = _calendarId ?? await _calSrv.getPersonalCalendarId(uid);
      if (calId == null) {
        setState(() => _error = 'Aucun agenda personnel trouvé');
        return;
      }
      final data = await _evtSrv.countByMonth(
        calendarId: calId,
        year: _yearAnchor.year,
      );
      if (!mounted) return;
      setState(() {
        _calendarId = calId;
        _eventsPerMonth = data;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  void _prevYear() {
    setState(() => _yearAnchor = DateTime(_yearAnchor.year - 1, 1, 1));
    _reloadYearCounts();
  }

  void _nextYear() {
    setState(() => _yearAnchor = DateTime(_yearAnchor.year + 1, 1, 1));
    _reloadYearCounts();
  }

  Future<void> _goToMonth(int month) async {
    if (_calendarId == null) return;
    await showMonthModal(
      context: context,
      calendarId: _calendarId!,
      yearAnchor: DateTime(_yearAnchor.year, 1, 1),
      month: month,
    );
    // refresh
    await _reloadYearCounts();
  }


  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, textAlign: TextAlign.center));
    }

    final crumbs = [
      BreadcrumbItem(label: 'Agenda', onTap: () {/* futur: retour dashboard */}),
      BreadcrumbItem(label: 'Année', isCurrent: true),
    ];
    final totalEvents = _eventsPerMonth.values.fold<int>(0, (a, b) => a + b);

    // 👉 Contenu pur (TimoraScaffold fournit déjà le Scaffold)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Breadcrumb(items: crumbs),
          const SizedBox(height: 8),

          // Toolbar année
          Row(
            children: [
              IconButton(
                tooltip: 'Année précédente',
                onPressed: _prevYear,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_yearAnchor.year}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                tooltip: 'Année suivante',
                onPressed: _nextYear,
                icon: const Icon(Icons.chevron_right),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Rafraîchir',
                onPressed: _reloadYearCounts,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Grille + pull-to-refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: _reloadYearCounts,
              child: YearGrid(
                year: _yearAnchor,
                eventsPerMonth: _eventsPerMonth,
                onMonthTap: _goToMonth,
                calendarId: _calendarId,
              ),
            ),
          ),

          if (totalEvents == 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Aucun événement sur ${_yearAnchor.year}.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
