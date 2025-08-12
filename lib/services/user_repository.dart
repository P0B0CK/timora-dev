import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createUserProfile(User user) async {
    final ref = _db.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) return; // idempotent

    await ref.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getMe(String uid) {
    return _db.collection('users').doc(uid).get();
  }

  Future<void> touchUpdatedAt(String uid) {
    return _db.collection('users').doc(uid).update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
