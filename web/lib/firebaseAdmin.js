import admin from "firebase-admin";

// Initializes the Firebase Admin SDK once (Admin SDK bypasses Firestore rules,
// which is why certificate issuance is safe to do here on the server).
function ensureApp() {
  if (admin.apps.length) return admin.app();
  const projectId = process.env.FIREBASE_PROJECT_ID;
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
  const privateKey = (process.env.FIREBASE_PRIVATE_KEY || "").replace(/\\n/g, "\n");

  if (!projectId || !clientEmail || !privateKey) {
    throw new Error("Firebase Admin env vars missing (FIREBASE_PROJECT_ID/CLIENT_EMAIL/PRIVATE_KEY)");
  }
  return admin.initializeApp({
    credential: admin.credential.cert({ projectId, clientEmail, privateKey }),
  });
}

export function db() {
  ensureApp();
  return admin.firestore();
}
