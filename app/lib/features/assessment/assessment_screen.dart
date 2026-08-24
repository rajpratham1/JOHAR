import 'package:flutter/material.dart';
import 'package:johar/l10n/app_localizations.dart';
import '../../core/services/local_store.dart';
import '../../core/theme.dart';
import '../../models/training_module.dart';
import '../certificate/certificate_screen.dart';
import 'assessment_engine.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key, required this.module});
  final TrainingModule module;

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  late final AssessmentEngine _engine = AssessmentEngine(widget.module);
  int _i = 0;

  void _finish() {
    final result = _engine.grade();
    if (result.passed) LocalStore.markModuleDone(widget.module.id);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => _ResultScreen(module: widget.module, result: result),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final lang = LocalStore.langCode;
    final total = widget.module.questions.length;
    final q = widget.module.questions[_i];
    final selected = _engine.selected(_i);
    final isLast = _i == total - 1;

    return Scaffold(
      appBar: AppBar(title: Text(t.assessmentTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(value: (_i + 1) / total),
              const SizedBox(height: 8),
              Text(t.questionProgress(_i + 1, total), style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),
              Text(q.promptFor(lang), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: q.options.length,
                  itemBuilder: (_, idx) {
                    final chosen = selected == idx;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: chosen ? const Color(0xFFE9F6EF) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: chosen ? kBrand : kLine, width: chosen ? 2 : 1),
                      ),
                      child: RadioListTile<int>(
                        value: idx,
                        groupValue: selected,
                        activeColor: kBrand,
                        title: Text(q.optionFor(idx, lang), style: const TextStyle(fontSize: 16)),
                        onChanged: (v) => setState(() => _engine.answer(_i, v!)),
                      ),
                    );
                  },
                ),
              ),
              FilledButton(
                onPressed: selected == null
                    ? null
                    : () => isLast ? _finish() : setState(() => _i++),
                child: Text(isLast ? t.submit : t.next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  const _ResultScreen({required this.module, required this.result});
  final TrainingModule module;
  final AssessmentResult result;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final passed = result.passed;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(passed ? Icons.verified : Icons.error_outline,
                  size: 96, color: passed ? kBrand : Colors.redAccent),
              const SizedBox(height: 16),
              Text(passed ? t.passTitle : t.failTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(t.yourScore(result.percent),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.black54)),
              const SizedBox(height: 32),
              if (passed)
                FilledButton.icon(
                  icon: const Icon(Icons.workspace_premium),
                  onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => CertificateScreen(module: module, score: result.percent),
                  )),
                  label: Text(t.getCertificate),
                )
              else
                FilledButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => Navigator.of(context).pop(),
                  label: Text(t.retry),
                ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: Text(t.backHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
