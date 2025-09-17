import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:timora/services/registration_flow.dart';
import 'package:timora/services/auth_service.dart';
import 'package:timora/services/backend_service.dart';
import 'package:timora/services/user_repository.dart';

// Mocks
class _MockAuthService extends Mock implements AuthService {}
class _MockBackendService extends Mock implements BackendService {}
class _MockUserRepository extends Mock implements UserRepository {}
class _MockUser extends Mock implements User {}
class _FakeUserCredential extends Fake implements UserCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeUserCredential());
  });

  test('Inscription => crée/récupère agenda et le persiste dans le profil', () async {
    final auth = _MockAuthService();
    final backend = _MockBackendService();
    final users = _MockUserRepository();

    final flow = RegistrationFlow(auth: auth, backend: backend, users: users);

    // Arrange
    final mockUser = _MockUser();
    when(() => mockUser.uid).thenReturn('uid_123');

    when(() => auth.register(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => _UserCredentialWithUser(mockUser));

    when(() => backend.getOrCreateDefaultCalendarId())
        .thenAnswer((_) async => 'cal_456');

    when(() => users.updateMe('uid_123', {'personalCalendarId': 'cal_456'}))
        .thenAnswer((_) async => {});

    // Act
    final (uid, calendarId) = await flow.registerAndBootstrap(
      email: 'test@timora.app',
      password: 'Password!23',
    );

    // Assert
    expect(uid, 'uid_123');
    expect(calendarId, 'cal_456');

    verify(() => auth.register(email: 'test@timora.app', password: 'Password!23')).called(1);
    verify(() => backend.getOrCreateDefaultCalendarId()).called(1);
    verify(() => users.updateMe('uid_123', {'personalCalendarId': 'cal_456'})).called(1);
    verifyNoMoreInteractions(auth);
    verifyNoMoreInteractions(backend);
    verifyNoMoreInteractions(users);
  });
}

/// Petit helper pour fournir un .user sur le résultat mocké
class _UserCredentialWithUser extends _FakeUserCredential {
  final User _user;
  _UserCredentialWithUser(this._user);
  @override
  User? get user => _user;
}
