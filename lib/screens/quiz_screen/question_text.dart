import '../../providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionText extends ConsumerWidget {
  const QuestionText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    final theme = Theme.of(context).textTheme;

    // Watch the AsyncValue of questions
    final questionsAsyncValue = ref.watch(questionProvider);

    return questionsAsyncValue.when(
      data: (questions) {
        // Data is available, display the question text
        if (questions.isEmpty) {
          return const Center(child: Text('No question available.'));
        }

        // Get the current question index
        final index = ref.watch(currentIndexProvider);

        // Ensure the index is valid
        if (index >= questions.length || index < 0) {
          return const Center(child: Text('Invalid question index.'));
        }

        final question =
            questions[index]; // Access the current question from the list

        return SingleChildScrollView(
          child: Text(
            'Question : ${question.questionText}',
            style: isTablet ? theme.titleLarge : theme.titleMedium,
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ), // Show loading indicator
      error: (err, st) => Center(
        child: Text('Error loading question: ${err.toString()}'),
      ), // Show error message
    );
  }
}
