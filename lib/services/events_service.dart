import 'package:cloud_firestore/cloud_firestore.dart';

class EventsService {
  final _db = FirebaseFirestore.instance;

  Future<Map<int, int>> countByMonth({
    required String calendarId,
    required int year,
  }) async {
    final start = DateTime.utc(year, 1, 1);
    final end = DateTime.utc(year + 1, 1, 1);

    final snap = await _db.collection('events')
        .where('calendarId', isEqualTo: calendarId)
        .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('startAt', isLessThan: Timestamp.fromDate(end))
        .get();

    final map = <int, int>{};
    for (final d in snap.docs) {
      final ts = d.data()['startAt'] as Timestamp;
      final m = ts.toDate().toLocal().month; // on compte dans le fuseau local
      map[m] = (map[m] ?? 0) + 1;
    }
    return map;
  }
}
