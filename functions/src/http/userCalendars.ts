// functions/src/http/userCalendars.ts
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { Timestamp } from 'firebase-admin/firestore';
import { initializeApp, getApps } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

function db() {
  if (getApps().length === 0) initializeApp();
  return getFirestore();
}

export const getOrCreateDefaultCalendar = onCall(
  { region: 'europe-west1' },
  async (req) => {
    const uid = req.auth?.uid;
    if (!uid) throw new HttpsError('unauthenticated', 'Auth required');

    const store = db();
    const calendarId = `${uid}_default`;
    const calRef = store.doc(`calendars/${calendarId}`);
    const snap = await calRef.get();

    if (!snap.exists) {
      await calRef.set({
        ownerId: uid,
        title: 'My Calendar',
        createdAt: Timestamp.now(),
      });
    }
    return { calendarId };
  }
);
