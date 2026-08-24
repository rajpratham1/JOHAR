import 'question.dart';

/// A single step within a module (an info card or an AR practice step).
class ModuleStep {
  final String type; // 'info' | 'ar'
  final Map<String, String> title;
  final Map<String, String> body;

  const ModuleStep({required this.type, required this.title, required this.body});

  factory ModuleStep.fromJson(Map<String, dynamic> j) => ModuleStep(
        type: (j['type'] as String?) ?? 'info',
        title: Map<String, String>.from(j['title'] as Map),
        body: Map<String, String>.from(j['body'] as Map),
      );

  String titleFor(String l) => title[l] ?? title['en'] ?? '';
  String bodyFor(String l) => body[l] ?? body['en'] ?? '';
}

/// A safety training module, loaded from a bundled JSON asset (offline-ready).
class TrainingModule {
  final String id;
  final Map<String, String> title;
  final String domain;
  final int estimatedMinutes;
  final List<ModuleStep> steps;
  final List<Question> questions;

  const TrainingModule({
    required this.id,
    required this.title,
    required this.domain,
    required this.estimatedMinutes,
    required this.steps,
    required this.questions,
  });

  factory TrainingModule.fromJson(Map<String, dynamic> j) => TrainingModule(
        id: j['id'] as String,
        title: Map<String, String>.from(j['title'] as Map),
        domain: (j['domain'] as String?) ?? '',
        estimatedMinutes: (j['estimatedMinutes'] as int?) ?? 5,
        steps: (j['steps'] as List)
            .map((s) => ModuleStep.fromJson(s as Map<String, dynamic>))
            .toList(),
        questions: (j['questions'] as List)
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList(),
      );

  String titleFor(String l) => title[l] ?? title['en'] ?? id;
}
