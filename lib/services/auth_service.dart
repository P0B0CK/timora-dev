import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Écoute les changements d'état (connexion/déconnexion)
  Stream<User?> get userStream => _auth.authStateChanges();

  /// Utilisateur courant
  User? get currentUser => _auth.currentUser;

  // ---------------------------------------------------------------------------
  // Helpers Firestore
  // ---------------------------------------------------------------------------
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
    }).catchError((_) async {
      final u = _auth.currentUser;
      if (u != null) {
        await _createUserProfileIfNeeded(u);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Auth: Inscription / Connexion / Déconnexion
  // ---------------------------------------------------------------------------
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

  Future<void> logout() async => _auth.signOut();
  Future<void> signOut() => logout();

  /// Réinitialisation du mot de passe
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ---------------------------------------------------------------------------
  // Opérations sensibles: réauthentification
  // ---------------------------------------------------------------------------
  Future<UserCredential> reauthenticate(String email, String password) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NO_USER',
        message: 'Aucun utilisateur connecté',
      );
    }
    final cred = EmailAuthProvider.credential(email: email, password: password);
    return await user.reauthenticateWithCredential(cred);
  }

  // ---------------------------------------------------------------------------
  // Édition de profil côté Auth (affichage)
  // ---------------------------------------------------------------------------
  Future<void> updateDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.updateDisplayName(displayName);
    await user.reload();
  }

  // ---------------------------------------------------------------------------
  // Changement d'email (protégé) - firebase_auth v6
  // NOTE: updateEmail(...) a été retiré. Il faut utiliser verifyBeforeUpdateEmail.
  // La mise à jour effective a lieu après que l'utilisateur clique le lien reçu.
  // ---------------------------------------------------------------------------
  Future<void> updateEmailSecure(
      String newEmail, {
        required String currentEmail,
        required String currentPassword,
      }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // 1) Réauthentification requise (opération sensible)
    await reauthenticate(currentEmail, currentPassword);

    // 2) Envoi d'un email de vérification à la nouvelle adresse
    //    IMPORTANT : le paramètre ActionCodeSettings est positionnel (pas nommé)
    //    Tu peux passer _actionCodeSettings() ou simplement omettre l'argument.
    await user.verifyBeforeUpdateEmail(
      newEmail,
      _actionCodeSettings(), // <-- positionnel optionnel
    );

    // 3) Après clic sur le lien, utilise finalizeEmailChangeSync() pour recharger
    //    l'utilisateur et synchroniser Firestore si tu stockes l'email.
  }

  /// À appeler après que l'utilisateur ait validé le lien de changement d'email.
  /// Recharge l'utilisateur et synchronise le champ `email` dans Firestore si besoin.
  Future<void> finalizeEmailChangeSync() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.reload();
    final refreshed = _auth.currentUser;
    if (refreshed != null) {
      await _db.collection('users').doc(refreshed.uid).set(
        {'email': refreshed.email, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
    }
  }

  /// ActionCodeSettings recommandé pour ramener l'utilisateur dans l'app
  ActionCodeSettings _actionCodeSettings() {
    return ActionCodeSettings(
      url: 'https://timora.example.com/auth/finish-email-update', // TODO: remplace par ton URL
      handleCodeInApp: true,
      androidPackageName: 'com.timora.app', // TODO
      androidInstallApp: true,
      androidMinimumVersion: '21',
      iOSBundleId: 'com.timora.app', // TODO
    );
  }

  // ---------------------------------------------------------------------------
  // Suppression de compte (protégée)
  // ---------------------------------------------------------------------------
  Future<void> deleteAccount({
    required String currentEmail,
    required String currentPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await reauthenticate(currentEmail, currentPassword);
    await user.delete();
    // Optionnel : ton UI peut ensuite supprimer le doc Firestore users/{uid}
    // via UserRepository.deleteProfileDoc(uid).
  }
}
