import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timora/services/calendar_service.dart';
import 'package:timora/services/events_service.dart';
import 'package:timora/ui/atoms/breadcrumb/breadcrumb_atom.dart';
import 'package:timora/ui/atoms/breadcrumb/breadcrumb_item.dart';
import 'package:timora/ui/organisms/calendar/year/year_grid.dart';

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
      final counts = await _evtSrv.countByMonth(calendarId: calId, year: _yearAnchor.year);
      if (!mounted) return;
      setState(() {
        _calendarId = calId;
        _eventsPerMonth = counts;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _goToMonth(int month) {
    // TODO: Navigator.pushNamed(context, '/calendar/month', arguments: {
    //   'calendarId': _calendarId, 'year': _yearAnchor.year, 'month': month
    // });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mois $month')),
    );
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
      BreadcrumbItem(label: 'Agenda', onTap: () {/* future: retour dashboard */}),
      BreadcrumbItem(label: 'Année', isCurrent: true),
    ];

    // 👉 Contenu pur : pas de Scaffold ici
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Breadcrumb(items: crumbs),
          const SizedBox(height: 8),
          Expanded(
            child: YearGrid(
              year: _yearAnchor,
              eventsPerMonth: _eventsPerMonth,
              onMonthTap: _goToMonth,
            ),
          ),
        ],
      ),
    );
  }
}
