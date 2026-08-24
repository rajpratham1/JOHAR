# JOHAR — SIH 2026 Master Blueprint
### AR-Based Vocational Training & Safety Certification Platform · Problem Statement 26041

> **Client:** Government of Jharkhand — Dept. of Higher & Technical Education
> **Category:** Software · **Theme:** Blockchain & Cybersecurity
> **Our recommended name:** **JOHAR** — *Jharkhand Occupational Hazard Awareness & Response*
> **Tagline options:** *"हर श्रमिक, सुरक्षित" (Every worker, safe)* · *"AR safety training in your language — verified on-chain."*

---

## 0. TL;DR (the 30-second pitch)

JOHAR is a **markerless-AR safety trainer that runs on any mid-range Android phone with no headset**. A young tribal recruit points their camera at the workplace and practises life-saving drills — putting out a virtual fire, selecting the right PPE for a gas leak, locking out a machine — in **Hindi and Santali, with voice narration for low-literacy workers, fully offline**. After passing an assessment, they get a **QR certificate whose authenticity is anchored on a public blockchain** (so it cannot be faked), and employers / DGMS see live compliance on a **web dashboard**. This directly attacks the PS's core pain: classroom retention is under 20%, and 48 people died in Jharkhand mines in 2022–23, many with under 30 days of orientation.

---

## 1. The problem, decoded (what the judges actually want)

The PS is dense. Stripped down, they are grading you on five things:

1. **Reach the un-reachable worker.** No headset, mid-range Android 10+, works where there is no signal (offline), and speaks the worker's language (Hindi + Santali). This is an *inclusion* problem as much as a tech problem — many workers have low literacy, so **audio + icons beat text**.
2. **Prove it teaches.** Static manuals give <20% retention. AR "learn-by-doing" + an **assessment engine** must demonstrably raise comprehension. Gamified, repeatable, measurable.
3. **Make certification trustworthy.** The Mines Act 1952 & Factories Act 1948 mandate periodic certification, but paper certs can't verify comprehension and are forgeable. Your answer = **QR + blockchain-anchored certificates** (this is your Theme fit — Blockchain).
4. **Give the regulator visibility.** A **web admin compliance dashboard** for employers and DGMS — who's trained, who's expired, which site is at risk.
5. **Ship something real.** A working **APK**, a **demo video**, and a **public GitHub repo**. Judges want to run it, not read about it.

Because the theme is **Blockchain & Cybersecurity**, you must visibly deliver *both* halves — blockchain for certificate integrity, and a clear cybersecurity story (secure auth, role-based access, encrypted local data, tamper-proof records). Section 10 covers this so it isn't an afterthought.

---

## 2. Project name & identity

### Recommendation: **JOHAR** ✅

**Why it's the strongest choice:**

- **It's a real word your users say.** *Johar* (ᱡᱳᱦᱟᱨ) is the traditional Adivasi / Santali greeting of respect used across Jharkhand — literally a salute to another human being. Naming the app after it says *"we respect and protect the worker."* For a Govt-of-Jharkhand tribal-welfare project, this lands emotionally with judges in a way no English acronym can.
- **It doubles as a perfect acronym:** **J**harkhand **O**ccupational **H**azard **A**wareness & **R**esponse — which is *exactly* what the product does.
- **It name-drops the client** (Jharkhand) and the mission (hazard awareness & response) in one memorable, 2-syllable, easy-to-pronounce word.
- **Unique in this space** — no crowded field of "JOHAR safety apps," unlike "Suraksha/Safety" apps.

**Tagline:** *"हर श्रमिक, सुरक्षित"* (Har Shramik, Surakshit — "Every worker, safe") for the Indian audience; *"Learn in AR. Certified on-chain."* for the tech pitch.

### Alternatives (if you want a different vibe)

| Name | Root / meaning | Why it works | Watch-out |
|---|---|---|---|
| **JOHAR** *(recommended)* | Adivasi greeting of respect **+** acronym | Cultural resonance + client + describes the product | Frame it respectfully in the pitch (honouring, not appropriating) |
| **KAVACH** | कवच = shield / armour | Powerful "protection" metaphor, punchy | Indian Railways' anti-collision system is also "Kavach" (different domain, but be aware) |
| **PRAHARI** | प्रहरी = sentinel / guardian | Dignified, uncommon, "always watching over you" | Slightly less "tech/AR" signal |
| **SAJAG** | सजग = alert / vigilant | Short, action-oriented ("stay alert") | A bit generic |
| **SURAKSHA NETRA** | सुरक्षा नेत्र = "safety eye" | Ties directly to AR camera-vision | Two words; "Suraksha" is very common |

My strong pick is **JOHAR**. It's the rare name that is meaningful, culturally intelligent, unique, *and* an accurate acronym — everything you asked for. The rest of this document uses "JOHAR," but swapping the name later costs nothing.

---

## 3. Requirement & deliverable compliance matrix (what output it needs)

Every item the PS demands, mapped to how JOHAR delivers it. **This is your submission checklist.**

| # | PS requirement | JOHAR delivers | Priority |
|---|---|---|---|
| 1 | Working **Android APK**, mid-range, **Android 10+**, **no headset** | Flutter APK, markerless AR via ARCore, with a non-AR fallback so it runs on *any* device | 🔴 Must |
| 2 | **≥ 2 complete AR training modules** | Framework for **all 5**; **build 2–3 fully** (Fire & Explosion, Gas/Confined Space [+ Machinery]) | 🔴 Must |
| 3 | **Assessment engine** | Per-module quizzes + in-AR scored tasks, pass threshold, retries, analytics | 🔴 Must |
| 4 | **QR-based certificate generation + verification** | On-device PDF cert + QR → **blockchain-anchored** hash → public verify portal | 🔴 Must |
| 5 | **Hindi + Santali** localisation | `intl`/ARB for hi + sat (Ol Chiki) + en, **plus voice narration** in each | 🔴 Must |
| 6 | **Offline functionality** | Firestore offline persistence + bundled assets + local DB with sync queue | 🔴 Must |
| 7 | **Web admin compliance dashboard** | Next.js dashboard on Vercel: completion, expiry, site risk, exports | 🔴 Must |
| 8 | **Demo video** | 3–4 min scripted walkthrough (worker journey → cert → dashboard) | 🔴 Must |
| 9 | **Public GitHub repository** | Monorepo (app / web / contracts / functions / docs) + clean README | 🔴 Must |
| 10 | Covers **5 safety domains** across mining/steel/mica | All 5 designed (see §7); demo-ready for 2–3 | 🟠 Strong |
| 11 | **Blockchain & Cybersecurity** theme fit | On-chain cert registry (§9) + security architecture (§10) | 🔴 Must (theme) |

Legend: 🔴 mandatory to pass · 🟠 strongly expected.

---

## 4. How JOHAR *exceeds* the requirement

You said this must go **beyond** the minimum. These are the features that turn a passing project into a winning one — each is tied to a real need in the PS:

- **Voice-first, icon-first UI for low-literacy workers.** The PS target user is "young tribal recruits with no prior industrial exposure." Text-only apps exclude them. Every screen has **audio narration** + large icons in Hindi & Santali. *This is the single biggest differentiator and directly serves the actual user.*
- **All 5 modules designed** (not just the required 2), so the platform looks production-ready.
- **Gamification** — badges, streaks, leaderboards, points. Directly attacks the "<20% retention" problem the PS cites.
- **Spaced-repetition refreshers + expiry reminders** (FCM push) — enforces the *periodic* re-certification the Mines/Factories Acts require.
- **AR-optional graceful fallback** — if a phone doesn't support ARCore, the same module runs as an interactive 3D/video drill. Nobody is left out (and your demo never crashes).
- **Blockchain-verified public certificate portal** — scan any JOHAR QR → instant tamper-proof verification, even by someone without the app.
- **DGMS / regulator analytics** — site-wise risk heatmaps, weak-topic detection ("40% of workers fail gas-leak PPE selection → retrain"), exportable compliance reports (CSV/PDF).
- **Scalable localisation** — architecture supports adding Ho, Mundari, Kurukh (other Jharkhand tribal languages) with zero code changes.
- **Cybersecurity hardening** as a first-class story (see §10), not an afterthought — matches the theme.

---

## 5. System architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                       WORKER (mid-range Android)                  │
│  Flutter APK  ── ARCore (markerless AR) ── on-device 3D/quiz      │
│  Hindi/Santali + voice · Offline-first (Hive/Drift + Firestore)   │
└───────────────┬───────────────────────────────┬──────────────────┘
                │ (sync when online)             │ generates
                ▼                                ▼
┌───────────────────────────────┐     ┌──────────────────────────────┐
│         FIREBASE (BaaS)        │     │   Certificate (PDF + QR)      │
│  Auth (phone OTP + roles)      │     │   hash of cert data           │
│  Firestore (offline sync)      │     └───────────────┬──────────────┘
│  Storage (3D/video/audio/PDFs) │                     │ anchor hash
│  Cloud Functions · FCM         │                     ▼
└───────────────┬────────────────┘     ┌──────────────────────────────┐
                │ Admin SDK             │  VERCEL (Next.js)             │
                │                       │  • Admin compliance dashboard │
                ▼                       │  • Public verify portal       │
        ┌───────────────┐              │  • Serverless API (ethers.js) │
        │ Employer/DGMS │◀─────────────┤        │                      │
        │  dashboard    │   analytics  └────────┼──────────────────────┘
        └───────────────┘                       ▼
                                   ┌──────────────────────────────┐
                                   │  POLYGON Amoy testnet         │
                                   │  CertificateRegistry contract │
                                   │  (hash → issuance record)     │
                                   └──────────────────────────────┘
```

**Data flow in one line:** Worker trains offline → passes assessment → cert generated on-device → when online, its hash is anchored on Polygon → QR points to the Vercel verify portal → employer/DGMS see it live on the dashboard.

---

## 6. Tech-stack decisions (and where I improved your plan)

Your instinct was **Flutter + Firebase + backend on Vercel + admin website**. That's a genuinely good stack — here's the confirmed version, plus three corrections/upgrades.

| Layer | Choice | Notes |
|---|---|---|
| **Mobile app** | **Flutter (Dart)** ✅ | Your call — correct. One codebase, great perf on mid-range. |
| **AR** | **ARCore** via `ar_flutter_plugin` (markerless plane detection + `.glb` models) | Meets "no headset." **Must ship a non-AR fallback** for unsupported devices. |
| **3D on-screen** | `model_viewer_plus` / `flutter_3d_controller` | Powers the fallback + model previews. |
| **Auth** | Firebase **Phone OTP** + role custom-claims (worker / supervisor / admin) | Phone-OTP beats email for workers. |
| **Database** | **Cloud Firestore** ✅ | Your call — correct, *specifically* because its **offline persistence** solves requirement #6 for free. |
| **Assets** | Firebase **Storage** | 3D models, videos, audio narration, generated PDFs. |
| **Local/offline** | **Hive** (or **Drift**) + Firestore cache + bundled module assets | True offline-first with a sync queue. |
| **Backend** | **Serverless** — Next.js API routes on Vercel **+** Firebase Cloud Functions | See correction #1 below. |
| **Web (admin + verify)** | **Next.js (React)** on **Vercel** ✅ | Your React skills fit perfectly. |
| **Blockchain** | **Solidity** contract on **Polygon Amoy testnet**, `ethers.js`, Hardhat | Free, fast, EVM tooling. See §9. |
| **Notifications** | Firebase **Cloud Messaging** | Recert reminders, new modules. |
| **State mgmt** | **Riverpod** (recommended) or Bloc | Clean, testable. |
| **QR** | `qr_flutter` (generate) + `mobile_scanner` (verify) | — |
| **Localization** | `flutter_localizations` + `intl` + ARB files (hi, sat, en) + Noto Sans Ol Chiki font | Santali uses the **Ol Chiki** script — bundle the font. |

**Three improvements over the original plan:**

1. **"Backend on Vercel" → serverless, not a monolith.** For a hackathon you don't want an always-on Node/Express server to babysit. Put your custom logic in **Next.js API routes / Vercel Functions** (blockchain anchoring & verification, PDF generation, privileged admin ops) and **Firebase Cloud Functions** (triggers, scheduled recert reminders). Cheaper, scales itself, less to break on demo day. Firebase already *is* most of your backend.

2. **Heads-up: you cannot deploy the Flutter *APK* on Vercel.** Vercel hosts the **web** (dashboard + verification portal + serverless APIs). The **APK** is distributed as a direct download / Play Store link — you can put that download button *on* the Vercel site. Easy to conflate; worth being precise in the pitch.

3. **ARCore has a supported-device list.** Not every "Android 10+ mid-range" phone supports ARCore. The **non-AR fallback mode** (interactive 3D + guided steps) is therefore non-negotiable — it guarantees the app works on the judges' device *and* honours the PS's inclusivity goal.

---

## 7. The 5 AR training modules

Design **all five**; build **2–3 end-to-end** for the APK. Modules 1–3 come straight from the PS; the PS text for module 3 was truncated and modules 4–5 weren't in our excerpt, so **4–5 are my recommendations — confirm against the full PS text** (see §18).

| # | Module | Core AR interactions | Sector | Build? |
|---|---|---|---|---|
| 1 | **Fire & Explosion Response** | Identify exits (AR route overlay), use extinguisher (PASS technique on virtual fire), evacuation sequencing | All | ✅ Build fully |
| 2 | **Gas Leak & Confined Space Protocol** | Recognise hazard zones, select correct PPE, buddy-system entry procedure | Mining/Steel | ✅ Build fully |
| 3 | **Machinery Safety — Lockout/Tagout & Entanglement** *(PS text truncated here)* | Spot moving-part hazards, apply LOTO on a virtual machine, guarding | Steel/Manufacturing | 🟠 Build if time (3rd module) |
| 4 | **Ground/Strata Control — Fall of Roof & Sides** *(recommended)* | Detect unsupported roof, place supports, read warning signs | Mining | 📐 Designed |
| 5 | **Electrical Safety & Emergency First Response** *(recommended)* | Isolate power, safe distances, basic first aid / SOS | All | 📐 Designed |

> **Why #4 & #5:** Fall of roof/sides is historically the **leading cause of underground mine fatalities** in India (a DGMS priority), and electrical + first-response is cross-sector. If the full PS names different domains 4–5, we swap them in — the module framework is generic.

**Module anatomy (reusable template):** intro (video/animation) → AR guided practice → free-practice → **scored AR task + quiz** → pass/fail → progress saved → contributes to certificate. Every module is content-driven (defined in Firestore/JSON) so adding a module = adding data, not rewriting code.

---

## 8. Assessment engine

- **Two scoring surfaces:** (a) traditional MCQ/image-based quizzes per module, (b) **in-AR performance tasks** (did they pick the right extinguisher? follow the correct evacuation order? select proper PPE?) — scored automatically.
- **Config-driven:** questions/tasks live as data (Firestore + offline cache), so non-coders can add content and it works offline.
- **Rules:** pass threshold (e.g. 80%), limited retries, randomised question order, time tracking.
- **Comprehension focus:** the Acts require *verified comprehension* — so certificates only issue on a genuine pass, and results feed the dashboard's "weak topic" analytics for targeted retraining.
- **Accessibility:** every question has audio + icons; answers selectable by tapping images, not just reading text.

---

## 9. Certificates: QR + blockchain (the "Blockchain" half of the theme)

**Goal:** a certificate that is impossible to forge and verifiable by anyone, anywhere — even offline-issued, later anchored.

**How it works:**

1. On passing, the app generates a certificate (worker name/ID, module(s), score, issue + **expiry date** per Act periodicity, unique cert ID, issuing authority).
2. It computes a **SHA-256 hash** of the canonical certificate data.
3. When online, a **Vercel serverless function** (using `ethers.js` + a funded testnet wallet) calls the **`CertificateRegistry`** smart contract on **Polygon Amoy**, storing `certId → hash + timestamp + issuer`. The **transaction hash** is saved back to Firestore.
4. The **QR code** encodes the verification URL (`verify.johar.app/c/<certId>`).
5. **Verification:** anyone scans the QR → opens the public Vercel portal → the portal recomputes the hash and checks it against the on-chain record. Match = ✅ authentic (with a link to the blockchain proof). Any tampering changes the hash → ❌ fails.

**Why blockchain here is *right*, not decoration:** the value proposition is a **tamper-proof, independently-verifiable public record** that no single employer or official can secretly alter — exactly the trust gap the PS describes with paper certificates. Optional add-on: pin the cert PDF/metadata to **IPFS** (web3.storage/Pinata) and store its CID on-chain.

**Demo-safety:** always keep a **database-backed verification fallback** so if the testnet is slow during judging, verification still resolves instantly; the blockchain proof is shown as the trust layer on top.

---

## 10. Cybersecurity (the other half of the theme)

Don't let "Cybersecurity" be silent — make it a slide. JOHAR's security story:

- **Authentication & authorisation:** Firebase phone-OTP; **role-based access** via custom claims (worker / supervisor / DGMS-admin); least-privilege.
- **Firestore Security Rules:** server-enforced — a worker can only read/write their own records; only backend functions can issue certs.
- **Secret management:** the blockchain-signing **private key never touches the phone** — it lives as a Vercel/Firebase server secret. Anchoring is server-side only. (This is a deliberate, explainable design choice.)
- **Data protection:** encrypted local storage (Hive encryption) for cached personal data; HTTPS everywhere; signed URLs for Storage assets.
- **Integrity & audit:** certificates are immutable once issued; the blockchain anchor is a **tamper-evident audit log**.
- **Privacy:** collect the minimum PII; worker data governed by role-based rules; consider consent screens in-app.
- **Abuse resistance:** rate-limited OTP, server-side score validation (can't fake a "pass" from the client), replay-proof cert IDs.

---

## 11. Localisation & accessibility (Hindi / Santali + low-literacy)

- **Languages at launch:** English (dev), **Hindi** (`hi`), **Santali** (`sat`, **Ol Chiki** script — bundle *Noto Sans Ol Chiki*). Architecture ready for Ho/Mundari/Kurukh later.
- **Santali is a rare, high-signal differentiator** — very few apps localise to Ol Chiki. It shows real commitment to the tribal workforce and will stand out to Jharkhand judges. Source translations from a **native speaker** (don't machine-translate Ol Chiki blindly) and validate.
- **Voice narration in every language** — essential, because a large share of the target workers have low literacy. Audio + icons make the whole app usable without reading.
- **Icon-first UI, large touch targets, high contrast** — usable in gloves, low light, noisy mines.
- **Implementation:** `flutter_localizations` + `intl` + ARB files; audio clips per language in Storage (bundled for offline).

---

## 12. Offline-first strategy

The PS explicitly requires offline. JOHAR is offline-first by design:

- **Firestore offline persistence** (on by default on Android) caches reads/writes and syncs when connectivity returns.
- **All module assets** (3D models, videos, audio, quiz data) are **bundled in the APK or downloaded once** then cached — so training runs with zero signal.
- **Local DB (Hive/Drift)** stores progress, assessment results, and **pending certificates** in a **sync queue**; blockchain anchoring happens later when online.
- **Conflict strategy:** offline-first with queued sync; issued certs are immutable, so no merge conflicts on the record that matters.

---

## 13. Admin compliance dashboard (the website you asked for)

**Stack:** Next.js (React) + Firebase Admin SDK, deployed on **Vercel**. Three audiences via role-based views:

- **Employer / site manager:** enrol workers, assign modules, see completion %, upcoming/expired certifications, per-worker history.
- **DGMS / regulator:** aggregate compliance across sites, **site-wise risk heatmap**, drill-down, **exportable reports (CSV/PDF)** for statutory records.
- **Content admin:** create/edit modules, quizzes, translations (config-driven, no redeploy).

**Signature analytics (the "wow"):** completion & pass-rate trends, **weak-topic detection** ("60% fail confined-space PPE → schedule retraining"), certification-expiry pipeline (ties to mandatory periodic recert), and live **blockchain-verified** cert counts. The **public verification portal** lives here too.

---

## 14. Repo structure & deployment

**Public GitHub monorepo** (requirement #9):

```
johar/
├── app/            # Flutter (Dart) — the APK
├── web/            # Next.js — admin dashboard + verify portal (→ Vercel)
├── functions/      # Firebase Cloud Functions (triggers, reminders)
├── contracts/      # Solidity CertificateRegistry + Hardhat (→ Polygon Amoy)
├── assets/         # 3D models, audio, translation source
├── docs/           # architecture, setup, demo script, screenshots
└── README.md       # clear setup + how to build the APK + live links
```

**Deployment:**

- **Web + serverless APIs** → **Vercel** (auto-deploy from `web/`).
- **Cloud Functions** → Firebase.
- **Smart contract** → Polygon Amoy testnet (Hardhat deploy; commit the address).
- **APK** → build via `flutter build apk`, attach to a **GitHub Release**, and add a download button on the Vercel site.
- A clean, screenshot-rich **README** matters — judges skim it first.

---

## 15. Build roadmap & team roles

You're "not sure yet" on team size — so this assumes the **SIH-standard team of 6**, with notes on what to cut if you're smaller. **Cut order if short-staffed:** drop module 3, then trim dashboard analytics, then reduce languages to Hindi-only for the demo (keep Santali in the architecture).

**Suggested roles (team of 6):**

| Role | Owns |
|---|---|
| 1. Flutter/AR lead | ARCore integration, AR module framework, fallback mode |
| 2. Flutter dev | Assessment engine, localization, offline sync, QR, gamification |
| 3. Backend/Blockchain | Firebase functions, Solidity contract, anchoring + verification API |
| 4. Full-stack/web | Next.js admin dashboard + verify portal on Vercel |
| 5. UI/UX + content | Designs, 3D assets, module content, Hindi/Santali translations, voice-over |
| 6. Lead / QA / pitch | Device testing, demo video, README/docs, presentation, integration |

**Phased plan:**

| Phase | Focus | Exit criteria |
|---|---|---|
| **0 — Setup** | Repos, Firebase project, Flutter + Next.js scaffolds, design system, asset & translation pipeline | Empty app builds; CI green |
| **1 — Foundation** | Phone-OTP auth + roles, navigation, localization (hi/sat/en), offline DB, content model | Log in, switch language, works offline |
| **2 — Module 1** | AR framework + **Fire & Explosion** end-to-end + assessment | One full AR module passes & scores |
| **3 — Module 2 + engine** | **Gas/Confined Space** + generalised assessment + gamification | Two modules; badges/points |
| **4 — Certificates** | On-device cert + QR + Polygon contract + anchoring + verify portal | Scan QR → on-chain verify ✅ |
| **5 — Dashboard** | Next.js compliance dashboard, analytics, exports, FCM reminders | Employer/DGMS views live on Vercel |
| **6 — Polish & submit** | Voice narration, low-end optimization, (module 3 if time), device testing, **demo video**, README | APK + video + public repo submitted |

---

## 16. Risks & mitigations

| Risk | Mitigation |
|---|---|
| Device doesn't support ARCore | **Non-AR 3D/guided fallback** — same content, any device |
| Santali/Ol Chiki translation accuracy | Native-speaker review; **audio narration** reduces reliance on script literacy |
| Blockchain slow/flaky at demo | **DB-backed verification fallback**; blockchain shown as the trust layer on top |
| 3D asset time-sink | Use free CC / Sketchfab / Poly assets; keep **low-poly** for mid-range + small APK |
| Offline sync conflicts | Offline-first + queued sync; issued certs immutable |
| Demo-day failure | Pre-load assets, rehearse on the target device, keep a **recorded backup demo** |
| Scope creep (5 modules) | Build 2 fully, design the rest; modules are data-driven so more is cheap |

---

## 17. Final submission checklist

- [ ] **APK** — installs & runs on a mid-range Android 10+ phone (with AR fallback verified)
- [ ] **≥ 2 AR modules** complete with assessments (aim for 3)
- [ ] **QR certificate** generates, and **verification** resolves on-chain (+ fallback)
- [ ] **Hindi + Santali** throughout, with **voice narration**
- [ ] **Offline** flow demonstrated end-to-end
- [ ] **Admin dashboard** live on Vercel (employer + DGMS views)
- [ ] **Public GitHub repo** with clean README, screenshots, live links, contract address
- [ ] **Demo video** (3–4 min): worker trains → certified → dashboard → QR verify
- [ ] Theme visibly covered: **Blockchain** (certs) **+ Cybersecurity** (security slide)

---

## 18. Open decisions I need from you

1. **Modules 4 & 5** — our PS excerpt truncated module 3 and didn't show 4–5. Please paste the full "Description" so I can lock the exact five domains (I've proposed Fall-of-Roof and Electrical/First-Response).
2. **Team size** — confirm so I can finalise the role split and cut-scope order.
3. **Name** — confirm **JOHAR**, or pick an alternative from §2.
4. **Next action** — once you confirm, I can scaffold the repos (Flutter app + Next.js dashboard + Solidity contract), or build any single piece first (say, the AR Fire module, or the certificate/blockchain flow, or the dashboard).

---

*Prepared for rajpr · SIH 2026 · PS 26041 · Theme: Blockchain & Cybersecurity*
