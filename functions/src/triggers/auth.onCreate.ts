// import { onAuthUserCreate } from 'firebase-functions/v2/identity';
// import { initializeApp } from 'firebase-admin/app';
// import { getFirestore, Timestamp } from 'firebase-admin/firestore';
//
// // Initialise l'admin SDK (safe à appeler une fois par process)
// initializeApp();
//
// /**
//  * Trigger: à chaque création de compte Firebase Auth,
//  * - crée /users/{uid}
//  * - crée /calendars/{uid}_default
//  * - ajoute un event "Welcome" dans /events
//  */
// export const handleUserCreate = onAuthUserCreate(
//   { region: 'europe-west1' }, // adapte la région à ton besoin
//   async (event) => {
//     const db = getFirestore();
//
//     const uid = event.data?.uid;
//     if (!uid) return;
//
//     const email = event.data?.email ?? '';
//     const displayName =
//       event.data?.displayName ?? (email.split('@')[0] || 'User');
//
//     const now = Timestamp.now();
//     const calendarId = `${uid}_default`;
//
//     const batch = db.batch();
//
//     // /users/{uid}
//     const userRef = db.doc(`users/${uid}`);
//     batch.set(
//       userRef,
//       {
//         email,
//         displayName,
//         createdAt: now,
//         updatedAt: now,
//       },
//       { merge: true }
//     );
//
//     // /calendars/{uid}_default
//     const calRef = db.doc(`calendars/${calendarId}`);
//     batch.set(calRef, {
//       ownerId: uid,
//       title: 'My Calendar',
//       createdAt: now,
//     });
//
//     // /events/{autoId} — petit évènement de bienvenue (1h)
//     const evRef = db.collection('events').doc();
//     batch.set(evRef, {
//       title: 'Welcome to Timora ✨',
//       startAt: now,
//       endAt: Timestamp.fromMillis(now.toMillis() + 60 * 60 * 1000),
//       allDay: false,
//       createdBy: uid,
//       calendarId,
//       createdAt: now,
//       updatedAt: now,
//       notes: 'Agenda créé automatiquement.',
//     });
//
//     await batch.commit();
//   }
// );
