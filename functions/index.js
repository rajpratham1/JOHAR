/**
 * JOHAR Cloud Functions.
 *
 * 1) recertReminders  — daily scheduled push (FCM) to workers whose certificate
 *    expires within 30 days. The Mines Act 1952 / Factories Act 1948 require
 *    *periodic* re-certification, so this enforces the cadence.
 * 2) setUserRole      — admin-only callable to grant 'worker'|'supervisor'|'admin'
 *    role custom-claims. (Bootstrap the very first admin manually in the console.)
 */
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const { getAuth } = require("firebase-admin/auth");

initializeApp();
const db = getFirestore();

const THIRTY_DAYS_MS = 30 * 24 * 60 * 60 * 1000;

exports.recertReminders = onSchedule(
  { schedule: "every day 09:00", timeZone: "Asia/Kolkata" },
  async () => {
    const now = Timestamp.now();
    const soon = Timestamp.fromMillis(now.toMillis() + THIRTY_DAYS_MS);

    const snap = await db
      .collection("certificates")
      .where("revoked", "==", false)
      .where("expiresAt", ">=", now)
      .where("expiresAt", "<=", soon)
      .get();

    let sent = 0;
    for (const doc of snap.docs) {
      const cert = doc.data();
      const workerSnap = await db.collection("workers").doc(cert.workerId).get();
      const token = workerSnap.get("fcmToken");
      if (!token) continue;

      await getMessaging().send({
        token,
        notification: {
          title: "Safety certificate expiring soon",
          body: "Your JOHAR safety certification expires soon. Open the app to renew.",
        },
        data: { certId: doc.id, type: "recert_reminder" },
      });
      sent++;
    }
    console.log(`recertReminders: notified ${sent} worker(s).`);
  }
);

exports.setUserRole = onCall(async (request) => {
  if (request.auth?.token?.role !== "admin") {
    throw new HttpsError("permission-denied", "Only admins can set roles.");
  }
  const { uid, role } = request.data || {};
  if (!uid || !["worker", "supervisor", "admin"].includes(role)) {
    throw new HttpsError("invalid-argument", "Provide uid and a valid role.");
  }
  await getAuth().setCustomUserClaims(uid, { role });
  return { ok: true, uid, role };
});
