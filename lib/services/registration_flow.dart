// lib/services/registration_flow.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'backend_service.dart';
import 'user_repository.dart';

class RegistrationFlow {
  final AuthService auth;
  final BackendService backend;
  final UserRepository users;

  RegistrationFlow({
    required this.auth,
    required this.backend,
    required this.users,
  });

  /// Inscription + création/récup agenda perso + MAJ profil
  /// Retourne (uid, calendarId)
  Future<(String uid, String calendarId)> registerAndBootstrap({
    required String email,
    required String password,
  }) async {
    final cred = await auth.register(email: email, password: password);
    final user = cred.user;
    if (user == null) {
      throw StateError('Inscription impossible : aucun utilisateur Firebase.');
    }

    // Cloud Function : crée ou récupère l’agenda par défaut
    final calendarId = await backend.getOrCreateDefaultCalendarId();

    // Persiste l’ID d’agenda perso dans le profil user
    await users.updateMe(user.uid, {
      'personalCalendarId': calendarId,
    });

    return (user.uid, calendarId);
  }
}
