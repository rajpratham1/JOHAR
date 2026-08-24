import 'package:flutter_tts/flutter_tts.dart';

/// Voice narration — essential for low-literacy workers.
/// Note: on-device Santali TTS isn't generally available yet, so Santali
/// narration falls back to a Hindi voice. TODO(johar): bundle Santali audio
/// clips for true narration.
class TtsService {
  static final FlutterTts _tts = FlutterTts();

  static const Map<String, String> _langTag = {
    'en': 'en-IN',
    'hi': 'hi-IN',
    'sat': 'hi-IN',
  };

  static Future<void> speak(String text, String langCode) async {
    if (text.trim().isEmpty) return;
    try {
      await _tts.setLanguage(_langTag[langCode] ?? 'en-IN');
      await _tts.setSpeechRate(0.45);
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // TTS engine unavailable on this device — silently ignore.
    }
  }

  static Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
