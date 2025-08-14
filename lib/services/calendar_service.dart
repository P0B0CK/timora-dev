import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarService {
  final _db = FirebaseFirestore.instance;

  /// Retourne l'ID d'agenda perso stocké sur l'utilisateur,
  /// ou le trouve en cherchant calendars(ownerId==uid, isPersonal==true).
  Future<String?> getPersonalCalendarId(String uid) async {
    final userRef = _db.collection('users').doc(uid);
    final userSnap = await userRef.get();
    final fromUser = userSnap.data()?['personalCalendarId'] as String?;
    if (fromUser != null && fromUser.isNotEmpty) return fromUser;

    final q = await _db
        .collection('calendars')
        .where('ownerId', isEqualTo: uid)
        .where('isPersonal', isEqualTo: true)
        .limit(1)
        .get();

    if (q.docs.isEmpty) return null;
    return q.docs.first.id;
  }
}
