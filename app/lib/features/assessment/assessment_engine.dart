import '../../core/constants.dart';
import '../../models/training_module.dart';

class AssessmentResult {
  final int correct;
  final int total;
  const AssessmentResult(this.correct, this.total);

  int get percent => total == 0 ? 0 : ((correct / total) * 100).round();
  bool get passed => percent >= Constants.passPercent;
}

/// Pure scoring logic — kept free of Flutter imports so it can be unit-tested.
class AssessmentEngine {
  AssessmentEngine(this.module);
  final TrainingModule module;
  final Map<int, int> _answers = {}; // questionIndex -> selected option index

  int get total => module.questions.length;

  void answer(int question, int option) => _answers[question] = option;
  int? selected(int question) => _answers[question];

  AssessmentResult grade() {
    var correct = 0;
    for (var i = 0; i < module.questions.length; i++) {
      if (_answers[i] == module.questions[i].answer) correct++;
    }
    return AssessmentResult(correct, total);
  }
}
