# JOHAR

**Jharkhand Occupational Hazard Awareness & Response** — an AR-based vocational safety training & blockchain-verified certification platform for Jharkhand's mining, steel, and mica workers.

> Smart India Hackathon 2026 · Problem Statement **26041** · Govt. of Jharkhand — Dept. of Higher & Technical Education
> Category: Software · Theme: **Blockchain & Cybersecurity**

Point your phone camera at the workplace, practise life-saving drills in AR (fire, gas leak, machinery lockout) in **Hindi & Santali with voice narration**, pass an assessment, and receive a **QR certificate whose authenticity is anchored on a public blockchain**. Employers and DGMS see live compliance on a web dashboard. Works **fully offline** on mid-range Android (10+), **no headset required**.

---

## Monorepo layout

| Path | What it is | Stack | Deploys to |
|---|---|---|---|
| [`app/`](./app) | The worker's mobile app (the APK) | Flutter (Dart) + ARCore | Android device / Play Store |
| [`web/`](./web) | Admin compliance dashboard **+** public certificate verify portal **+** blockchain anchor API | Next.js (React) | Vercel |
| [`contracts/`](./contracts) | On-chain certificate registry | Solidity + Hardhat | Polygon Amoy testnet |
| [`functions/`](./functions) | Scheduled re-certification reminders | Firebase Cloud Functions | Firebase |
| [`firebase/`](./firebase) | Firestore/Storage security rules + indexes | — | Firebase |
| [`docs/`](./docs) | Blueprint, architecture, setup, demo script | — | — |

**Data flow:** worker trains offline → passes assessment → certificate generated on-device → when online, its hash is anchored on Polygon via `web/app/api/anchor` → QR points to `web/app/verify/[certId]` → employers/DGMS see it live on the dashboard.

---

## Quick start

Each sub-project has its own setup. In order:

### 1. Firebase (backend-as-a-service)
See [`docs/firebase-setup.md`](./docs/firebase-setup.md). Create the project, enable **Phone Auth**, **Firestore**, **Storage**, then deploy rules from [`firebase/`](./firebase).

### 2. Smart contract (`contracts/`)
```bash
cd contracts
npm install
cp .env.example .env          # add PRIVATE_KEY + AMOY_RPC_URL
npm run compile
npm test
npm run deploy:amoy           # prints the deployed contract address
```
Copy the deployed address into `web/.env` as `CERT_CONTRACT_ADDRESS`.

### 3. Web dashboard + verify portal (`web/`)
```bash
cd web
npm install
cp .env.example .env.local    # Firebase admin creds + contract address + signer key
npm run dev                   # http://localhost:3000
```
Deploy to Vercel by importing the repo and setting the same env vars.

### 4. Mobile app (`app/`)
```bash
cd app
flutter pub get
flutterfire configure         # generates firebase_options.dart
flutter gen-l10n              # builds Hindi/Santali/English localizations
flutter run                   # on a connected Android device
flutter build apk --release   # produces the submission APK
```

---

## Tech stack

Flutter + ARCore (markerless AR, with a non-AR 3D fallback for unsupported devices) · Firebase (Phone-OTP Auth, Firestore with offline persistence, Storage, FCM) · Next.js on Vercel · Solidity `CertificateRegistry` on Polygon Amoy (verified via `ethers.js`) · Riverpod · `intl` localization (Hindi `hi`, Santali `sat`/Ol Chiki, English `en`).

## Status

This is the hackathon **scaffold** — the architecture, contracts, security rules, i18n, and the learn → assess → certify vertical slice are wired. Search the code for `TODO(johar)` for the intended extension points (real AR scenes, more 3D assets, the remaining modules, dashboard analytics).

## License

MIT — see [`LICENSE`](./LICENSE).
