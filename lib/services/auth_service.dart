// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Écoute les changements d'état de l'utilisateur (connexion/déconnexion)
  Stream<User?> get userStream => _auth.authStateChanges();

  /// Renvoie l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  /// -- Helpers Firestore -----------------------------------------------------

  Future<void> _createUserProfileIfNeeded(User user) async {
    final ref = _db.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) return;

    await ref.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _touchUpdatedAt(String uid) async {
    await _db.collection('users').doc(uid).update({
      'updatedAt': FieldValue.serverTimestamp(),
    }).catchError((_) {
      // Si le doc n'existe pas (compte créé ailleurs), on le crée à la volée
      final u = _auth.currentUser;
      if (u != null) {
        return _createUserProfileIfNeeded(u);
      }
    });
  }

  /// -- Actions Auth ----------------------------------------------------------

  /// Inscription avec email et mot de passe
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user != null) {
      await _createUserProfileIfNeeded(user);
    }
    return cred;
  }

  /// Connexion avec email et mot de passe
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user != null) {
      await _createUserProfileIfNeeded(user);
      await _touchUpdatedAt(user.uid);
    }
    return cred;
  }

  /// Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Alias pratique pour certains appels UI
  Future<void> signOut() => logout();

  /// Réinitialisation du mot de passe
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
