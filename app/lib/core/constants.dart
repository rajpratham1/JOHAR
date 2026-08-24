class Constants {
  /// Your deployed Vercel base URL (no trailing slash). Used for QR verify
  /// links and the blockchain anchor API. Override at build time:
  ///   flutter run --dart-define=JOHAR_WEB_BASE=https://your-app.vercel.app
  static const String webBaseUrl = String.fromEnvironment(
    'JOHAR_WEB_BASE',
    defaultValue: 'https://johar.vercel.app',
  );

  /// Bundled module content (works fully offline).
  static const List<String> moduleAssets = [
    'assets/modules/fire_explosion.json',
    'assets/modules/gas_confined_space.json',
  ];

  static const Map<String, String> supportedLangs = {
    'en': 'English',
    'hi': 'हिन्दी',
    'sat': 'Santali (Ol Chiki)',
  };

  /// Pass mark for assessments (%). The Acts require verified comprehension.
  static const int passPercent = 80;
}
