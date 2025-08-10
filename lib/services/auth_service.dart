import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Écoute les changements d'état de l'utilisateur (connexion/déconnexion)
  Stream<User?> get userStream => _auth.authStateChanges();

  /// Renvoie l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  /// Inscription avec email et mot de passe
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Connexion avec email et mot de passe
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Réinitialisation du mot de passe
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
