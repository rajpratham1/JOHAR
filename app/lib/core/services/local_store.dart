import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple offline-first local store.
///
/// The scaffold uses SharedPreferences for clarity. In production, swap for
/// Hive/Drift (encrypted) and back it with Firestore offline persistence.
class LocalStore {
  static late SharedPreferences _prefs;

  /// Current UI language; null = follow device locale.
  static final ValueNotifier<Locale?> locale = ValueNotifier<Locale?>(null);

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final code = _prefs.getString('locale');
    if (code != null) locale.value = Locale(code);
  }

  static String get langCode => locale.value?.languageCode ?? 'en';

  static Future<void> setLocale(String code) async {
    await _prefs.setString('locale', code);
    locale.value = Locale(code);
  }

  static String? get workerName => _prefs.getString('workerName');
  static String get workerId => _prefs.getString('workerId') ?? 'anon';

  static Future<void> setWorker(String name, String phone) async {
    await _prefs.setString('workerName', name);
    await _prefs.setString(
      'workerId',
      phone.isEmpty ? 'worker-${DateTime.now().millisecondsSinceEpoch}' : phone,
    );
  }

  static bool isModuleDone(String id) =>
      (_prefs.getStringList('done') ?? const []).contains(id);

  static Future<void> markModuleDone(String id) async {
    final done = _prefs.getStringList('done') ?? [];
    if (!done.contains(id)) {
      done.add(id);
      await _prefs.setStringList('done', done);
    }
  }

  // --- Offline anchor queue: certs issued while offline sync later ---
  static List<String> pendingCerts() => _prefs.getStringList('pendingCerts') ?? [];

  static Future<void> addPendingCert(String json) async {
    final p = _prefs.getStringList('pendingCerts') ?? [];
    p.add(json);
    await _prefs.setStringList('pendingCerts', p);
  }

  /// Overwrite the pending queue (used after a sync flush leaves only failures).
  static Future<void> replacePending(List<String> items) async {
    await _prefs.setStringList('pendingCerts', items);
  }
}
