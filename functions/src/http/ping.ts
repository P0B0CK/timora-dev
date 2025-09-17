// functions/src/http/ping.ts
import { onCall } from 'firebase-functions/v2/https';

export const ping = onCall({ region: 'europe-west1' }, async (req) => {
  const uid = req.auth?.uid ?? null;
  return { ok: true, uid, ts: Date.now() };
});