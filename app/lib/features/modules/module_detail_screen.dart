import 'package:flutter/material.dart';
import 'package:johar/l10n/app_localizations.dart';
import '../../core/services/local_store.dart';
import '../../core/services/tts_service.dart';
import '../../core/theme.dart';
import '../../models/training_module.dart';
import '../assessment/assessment_screen.dart';
import 'ar_view_screen.dart';

class ModuleDetailScreen extends StatelessWidget {
  const ModuleDetailScreen({super.key, required this.module});
  final TrainingModule module;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final lang = LocalStore.langCode;
    return Scaffold(
      appBar: AppBar(title: Text(module.titleFor(lang))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final step in module.steps) _StepCard(step: step, lang: lang),
            const SizedBox(height: 8),
            FilledButton.icon(
              icon: const Icon(Icons.quiz),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => AssessmentScreen(module: module)),
              ),
              label: Text(t.takeTest),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step, required this.lang});
  final ModuleStep step;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isAr = step.type == 'ar';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(isAr ? Icons.view_in_ar : Icons.info_outline, color: kBrand),
            const SizedBox(width: 8),
            Expanded(
              child: Text(step.titleFor(lang),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(step.bodyFor(lang), style: const TextStyle(fontSize: 15, height: 1.4)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.volume_up),
                onPressed: () =>
                    TtsService.speak('${step.titleFor(lang)}. ${step.bodyFor(lang)}', lang),
                label: Text(t.listen),
              ),
              if (isAr)
                FilledButton.icon(
                  icon: const Icon(Icons.view_in_ar),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ArViewScreen(title: step.titleFor(lang))),
                  ),
                  label: Text(t.startAr),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
