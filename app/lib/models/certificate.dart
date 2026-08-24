/// The certificate object. Its canonical hash is computed server-side (see
/// web/lib/certHash.js) and anchored on-chain — the app just sends these fields.
class Certificate {
  final String certId;
  final String workerId;
  final String workerName;
  final List<String> modules;
  final int score;
  final String issuer;
  final String issuedAt; // ISO-8601
  final String expiresAt; // ISO-8601

  const Certificate({
    required this.certId,
    required this.workerId,
    required this.workerName,
    required this.modules,
    required this.score,
    required this.issuer,
    required this.issuedAt,
    required this.expiresAt,
  });

  Map<String, dynamic> toJson() => {
        'certId': certId,
        'workerId': workerId,
        'workerName': workerName,
        'modules': modules,
        'score': score,
        'issuer': issuer,
        'issuedAt': issuedAt,
        'expiresAt': expiresAt,
      };
}
