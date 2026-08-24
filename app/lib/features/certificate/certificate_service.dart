import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../core/services/local_store.dart';
import '../../models/certificate.dart';

enum AnchorStatus { anchored, queuedOffline }

/// Builds the certificate and sends it to the web `/api/anchor` endpoint, which
/// hashes it (keccak256) and writes it on-chain. Hashing is done server-side
/// ONLY — the app never holds the signing key. If the network is unavailable,
/// the cert is queued locally and synced later (offline-first).
class CertificateService {
  static Certificate build({required List<String> modules, required int score}) {
    final now = DateTime.now().toUtc();
    final expires = DateTime.utc(now.year + 1, now.month, now.day);
    final rand = (now.microsecondsSinceEpoch % 100000).toString().padLeft(5, '0');
    final certId = 'JOHAR-${now.millisecondsSinceEpoch}-$rand';
    return Certificate(
      certId: certId,
      workerId: LocalStore.workerId,
      workerName: LocalStore.workerName ?? 'Worker',
      modules: modules,
      score: score,
      issuer: 'JOHAR Training Authority',
      issuedAt: now.toIso8601String(),
      expiresAt: expires.toIso8601String(),
    );
  }

  static Future<AnchorStatus> anchor(Certificate cert) async {
    final body = json.encode(cert.toJson());
    if (await _post(body)) return AnchorStatus.anchored;
    await LocalStore.addPendingCert(body); // offline / error → retry later
    return AnchorStatus.queuedOffline;
  }

  /// Retries every queued certificate. Safe to call on app start / when back
  /// online — the /api/anchor endpoint is idempotent, so re-sending an already
  /// anchored cert just succeeds. Certs that still fail stay queued.
  static Future<void> flushPending() async {
    final pending = LocalStore.pendingCerts();
    if (pending.isEmpty) return;
    final remaining = <String>[];
    for (final body in pending) {
      if (!await _post(body)) remaining.add(body);
    }
    if (remaining.length != pending.length) {
      await LocalStore.replacePending(remaining);
    }
  }

  /// POSTs a cert JSON body to the anchor API. Returns true on a 2xx response.
  static Future<bool> _post(String body) async {
    try {
      final res = await http
          .post(
            Uri.parse('${Constants.webBaseUrl}/api/anchor'),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 12));
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false; // offline / timeout
    }
  }
}
