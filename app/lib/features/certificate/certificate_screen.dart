import 'package:flutter/material.dart';
import 'package:johar/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/constants.dart';
import '../../core/services/local_store.dart';
import '../../core/theme.dart';
import '../../models/certificate.dart';
import '../../models/training_module.dart';
import 'certificate_service.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key, required this.module, required this.score});
  final TrainingModule module;
  final int score;

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  late final Certificate _cert =
      CertificateService.build(modules: [widget.module.id], score: widget.score);
  AnchorStatus? _status; // null while anchoring

  @override
  void initState() {
    super.initState();
    _anchor();
  }

  Future<void> _anchor() async {
    final s = await CertificateService.anchor(_cert);
    if (mounted) setState(() => _status = s);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final lang = LocalStore.langCode;
    final verifyUrl = '${Constants.webBaseUrl}/verify/${_cert.certId}';

    return Scaffold(
      appBar: AppBar(title: Text(t.certTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kAmber, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium, size: 56, color: kAmber),
                  const SizedBox(height: 8),
                  Text(t.certTitle,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kBrandInk)),
                  const SizedBox(height: 4),
                  Text(t.certFor(_cert.workerName), style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(widget.module.titleFor(lang),
                      textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 16),
                  QrImageView(data: verifyUrl, version: QrVersions.auto, size: 180),
                  const SizedBox(height: 8),
                  Text(t.scanToVerify, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  SelectableText(_cert.certId,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _statusBanner(t),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: Text(t.backHome),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBanner(AppLocalizations t) {
    final IconData icon;
    final Color color;
    final String label;
    switch (_status) {
      case AnchorStatus.anchored:
        icon = Icons.verified;
        color = kBrand;
        label = t.anchored;
      case AnchorStatus.queuedOffline:
        icon = Icons.cloud_off;
        color = const Color(0xFFB8860B);
        label = t.queuedOffline;
      case null:
        icon = Icons.hourglass_top;
        color = Colors.black45;
        label = t.anchoring;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
