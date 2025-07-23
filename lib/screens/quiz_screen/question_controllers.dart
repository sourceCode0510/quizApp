import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/question_provider.dart';
import '../result_screen.dart';

class QuestionControllers extends ConsumerWidget {
  const QuestionControllers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsyncValue = ref.watch(
      questionProvider,
    ); // Watch the AsyncValue
    final currentQuestionIndex = ref.watch(currentIndexProvider);

    return questionsAsyncValue.when(
      data: (questions) {
        // Data is available, display the list

        final bool isFirstQuestion = currentQuestionIndex == 0;
        final bool isLastQuestion =
            currentQuestionIndex == questions.length - 1;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: isFirstQuestion
                  ? null // Disable if it's the first question
                  : () {
                      ref.read(questionProvider.notifier).previousQuestion();
                    },
              child: const Text('Previous'),
            ),
            ElevatedButton(
              onPressed: isLastQuestion
                  ? () {
                      Navigator.pushNamed(context, ResultScreen.name);
                    } // Disable if it's the last question
                  : () {
                      ref.read(questionProvider.notifier).nextQuestion();
                    },
              child: Text(isLastQuestion ? 'Finish' : 'Next'),
            ),
          ],
        );
      },
      error: (e, st) => Center(child: Text(e.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
