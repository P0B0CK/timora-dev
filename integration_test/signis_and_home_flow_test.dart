// integration_test/signin_and_home_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timora/main.dart' as app;

Future<void> _connectEmulators() async {
  // Par défaut localhost:9099 / 8080 — adapte si tu changes
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('New user -> seeded calendar -> Home renders',
          (WidgetTester tester) async {
        // 1) Init Firebase + émulateurs
        await Firebase.initializeApp();
        await _connectEmulators();

        // 2) Crée un user sur l’émulateur
        final email = 'it_${DateTime.now().millisecondsSinceEpoch}@timora.dev';
        const password = 'P@ssw0rd123!';
        final cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final uid = cred.user!.uid;

        // 3) Seed Firestore minimal : user + agenda perso
        final fs = FirebaseFirestore.instance;
        final calendarId = 'cal_${DateTime.now().millisecondsSinceEpoch}';
        await fs.collection('users').doc(uid).set({
          'email': email,
          'displayName': 'Test User',
          'personalCalendarId': calendarId,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
        await fs.collection('calendars').doc(calendarId).set({
          'ownerUid': uid,
          'title': 'Mon agenda',
          'isPersonal': true,
          'createdAt': DateTime.now().toIso8601String(),
        });

        // 4) Lance l’app et attends le rendu
        app.main();
        await tester.pumpAndSettle();

        // 5) Assert : la Home s’affiche (adapte le sélecteur à ton UI)
        // Si tu as un texte "Mon agenda" :
        expect(find.textContaining('Mon agenda'), findsWidgets);

        // Variante (si tu préfères) : chercher un widget clé de la Home
        // expect(find.byKey(const Key('home-year-grid')), findsOneWidget);
      });
}
