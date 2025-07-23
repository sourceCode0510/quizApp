import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'question_provider.dart';

typedef Result = Map<String, dynamic>;

final resultProvider = Provider<Result>((ref) {
  final asyncQuestions = ref.watch(questionProvider);

  return asyncQuestions.when(
    data: (questions) {
      int correct = 0;
      int incorrect = 0;
      int skipped = 0;

      if (questions.isEmpty) {
        return {};
      }

      for (var question in questions) {
        if (question.selectedOption == question.answer) {
          correct++;
        } else if (question.selectedOption == '') {
          skipped++;
        } else {
          incorrect++;
        }
      }
      return {
        'correct': correct,
        'incorrect': incorrect,
        'skipped': skipped,
        'score': ((correct / questions.length) * 100).abs(),
        'questionsCount': questions.length,
      };
    },
    error: (e, st) {
      return {};
    },
    loading: () {
      return {};
    },
  );
});
