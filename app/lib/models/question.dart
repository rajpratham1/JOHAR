/// A single assessment question with per-language text.
class Question {
  final Map<String, String> prompt;
  final List<Map<String, String>> options;
  final int answer; // index into options

  const Question({required this.prompt, required this.options, required this.answer});

  factory Question.fromJson(Map<String, dynamic> j) => Question(
        prompt: Map<String, String>.from(j['prompt'] as Map),
        options: (j['options'] as List)
            .map((o) => Map<String, String>.from(o as Map))
            .toList(),
        answer: j['answer'] as int,
      );

  String promptFor(String lang) => prompt[lang] ?? prompt['en'] ?? '';
  String optionFor(int i, String lang) => options[i][lang] ?? options[i]['en'] ?? '';
}
