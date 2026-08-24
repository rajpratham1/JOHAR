# Firebase setup

JOHAR uses Firebase for auth, database (with offline persistence), storage, and messaging.

## 1. Create the project
1. Go to the Firebase console → **Add project** → name it `johar-sih` (or similar).
2. Disable Google Analytics (optional) to keep it simple.

## 2. Enable services
- **Authentication → Sign-in method → Phone.** (For testing, add a few fictional test phone numbers with fixed OTPs so you don't burn SMS quota during the demo.)
- **Firestore Database → Create database** → start in *production* mode (rules are provided in `firebase/firestore.rules`).
- **Storage → Get started** (rules in `firebase/storage.rules`).
- **Cloud Messaging** — no setup needed beyond the SDK.

## 3. Data model (Firestore collections)
```
workers/{uid}            → { name, phone, employerId, role, langPref, createdAt }
employers/{employerId}   → { name, sector, district }
modules/{moduleId}       → { titleKey, domain, order, published }   (content also bundled in-app)
attempts/{attemptId}     → { workerId, moduleId, score, passed, answers, takenAt }
certificates/{certId}    → { workerId, workerName, modules[], score, issuedAt,
                             expiresAt, issuer, dataHash, txHash, revoked }
```
Custom claims on the auth token carry the role: `worker` | `supervisor` | `admin`.

## 4. Deploy rules
```bash
npm install -g firebase-tools
firebase login
firebase use --add            # select your project
firebase deploy --only firestore:rules,storage:rules,firestore:indexes
```
(Point the Firebase CLI at `firebase/` — see `firebase.json` you create at repo root, or run from within the folder.)

## 5. Connect the app
```bash
cd app
dart pub global activate flutterfire_cli
flutterfire configure          # writes lib/firebase_options.dart (git-ignored)
```

## 6. Connect the web/functions (admin)
- Generate a **service account** key (Project settings → Service accounts → Generate new private key).
- Put its values into `web/.env.local` and `functions/.env` (never commit them).

## Security notes
- The blockchain **signer private key** lives only in `web` server env / `functions` env — never in the app.
- Firestore rules (in `firebase/firestore.rules`) enforce that workers can only read/write their own records and that certificates are written by privileged code only.
