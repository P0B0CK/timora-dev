// lib/services/events_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventsService {
  final _db = FirebaseFirestore.instance;

  /// Compte par mois
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
      final m = ts.toDate().month;
      map[m] = (map[m] ?? 0) + 1;
    }
    return map;
  }

  /// Liste des events du mois
  Future<QuerySnapshot<Map<String, dynamic>>> eventsOfMonth(
      String calendarId,
      DateTime anchor,
      ) {
    final start = DateTime(anchor.year, anchor.month, 1);
    final end = (anchor.month == 12)
        ? DateTime(anchor.year + 1, 1, 1)
        : DateTime(anchor.year, anchor.month + 1, 1);

    return _db.collection('events')
        .where('calendarId', isEqualTo: calendarId)
        .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('startAt', isLessThan: Timestamp.fromDate(end))
        .orderBy('startAt')
        .get();
  }

  /// Création d’un event
  Future<DocumentReference<Map<String, dynamic>>> addEvent({
    required String calendarId,
    required String title,
    required DateTime startAt,
    required DateTime endAt,
    String? location,
    String? notes,
    bool? allDay,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('Utilisateur non connecté');

    return _db.collection('events').add({
      'title': title,
      'startAt': Timestamp.fromDate(startAt),
      'endAt': Timestamp.fromDate(endAt),
      'calendarId': calendarId,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
      if (allDay != null) 'allDay': allDay,
    });
  }
}
