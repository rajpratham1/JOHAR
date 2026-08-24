# JOHAR — Mobile app (Flutter)

The worker-facing Android app: AR safety training → assessment → QR + blockchain-verified certificate, in Hindi & Santali, offline-first.

## Run it
```bash
flutter pub get
flutter gen-l10n          # generates Hindi/Santali/English localizations
flutter run               # on a connected Android device (Android 10+)
```
If a package version fails to resolve, run `flutter pub upgrade` and adjust `pubspec.yaml` — versions here are conservative but may need a bump for your Flutter channel.

## Point it at your web backend
The QR verify links and the blockchain anchor call use your deployed Vercel URL. Pass it at build/run time:
```bash
flutter run --dart-define=JOHAR_WEB_BASE=https://your-app.vercel.app
flutter build apk --release --dart-define=JOHAR_WEB_BASE=https://your-app.vercel.app
```
Default is `https://johar.vercel.app` (see `lib/core/constants.dart`).

## What's wired vs TODO
Wired: trilingual UI + voice narration, module loading from JSON assets, the two safety modules (Fire & Explosion, Gas & Confined Space), the assessment engine, certificate generation with QR, offline queue for anchoring, and the anchor API call.

`TODO(johar)` extension points:
- **Real AR scenes** — `lib/features/modules/ar_view_screen.dart` is a functional placeholder + fallback. Wire `ar_flutter_plugin` (ARCore) and drop in `.glb` models.
- **Firebase** — auth is a local stub. Enable `firebase_*` in `pubspec.yaml`, run `flutterfire configure`, and swap the stub for phone-OTP + Firestore sync.
- **Santali (Ol Chiki) translations** — `lib/l10n/app_sat.arb` currently mirrors English as placeholders. **A native Santali speaker must replace these with Ol Chiki text.** Hindi (`app_hi.arb`) is complete.

## Structure
```
lib/
├── main.dart, app.dart
├── core/            theme, constants, services (local store, TTS)
├── l10n/            app_en / app_hi / app_sat .arb
├── models/          TrainingModule, Question, Certificate
└── features/        auth · home · modules · assessment · certificate
assets/modules/      fire_explosion.json · gas_confined_space.json
```
