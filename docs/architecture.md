# JOHAR — Architecture

This is the condensed engineering view. The full product blueprint is in
[`JOHAR_SIH2026_Blueprint.md`](./JOHAR_SIH2026_Blueprint.md).

## Components

```
Worker (Android)                      Firebase (BaaS)              Vercel (Next.js)          Polygon Amoy
─────────────────                     ───────────────              ────────────────          ────────────
Flutter APK                           Phone-OTP Auth + roles       Admin dashboard           CertificateRegistry
 ├─ ARCore (markerless)     <──sync──▶ Firestore (offline sync)    Public verify portal      (issue/verify/revoke)
 ├─ non-AR 3D fallback                Storage (3D/audio/PDF)       /api/anchor  ───tx───▶ ───┘
 ├─ Assessment engine                 Cloud Functions (reminders)  ethers.js signer
 ├─ hi / sat / en + TTS               FCM
 └─ Offline store (Hive)
```

## Certificate integrity (the trust model)

1. On passing, the app builds a **canonical certificate object** (certId, workerId, name, modules, score, issuedAt, expiresAt, issuer).
2. It computes `dataHash = keccak256(canonicalJson)`.
3. The QR encodes `https://<domain>/verify/<certId>`.
4. When online the app POSTs the cert to `web/app/api/anchor`, which (server-side, holding the signer key) calls `CertificateRegistry.issueCertificate(keccak256(certId), dataHash)` and writes the record to Firestore.
5. **Verification** (`web/app/verify/[certId]`): read the cert fields from Firestore → recompute `dataHash` → call `CertificateRegistry.verify(certId, dataHash)`. If anyone tampered with the stored fields, the recomputed hash won't match the on-chain hash → **invalid**.

The signing key **never** ships in the APK — anchoring is server-side only. This is the deliberate cybersecurity boundary.

## Offline-first

- Firestore offline persistence caches reads/writes and syncs on reconnect.
- Module content + 3D/audio assets are bundled or cached once, so training runs with zero signal.
- Assessment results and **pending certificates** queue locally (Hive) and anchor to chain when online.

## Why these choices

See blueprint §6. Short version: Firebase's offline persistence satisfies the offline requirement almost for free; serverless (Vercel + Cloud Functions) means nothing to babysit on demo day; Polygon Amoy is free, fast, and EVM-tooled.
