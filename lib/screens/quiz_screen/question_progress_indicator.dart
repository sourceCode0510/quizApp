import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/question_provider.dart';

class QuestionProgressIndicator extends ConsumerWidget {
  const QuestionProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    final gap = isTablet ? 20.0 : 10.0;
    final theme = Theme.of(context).textTheme;

    // Watch the AsyncValue of questions
    final questionsAsyncValue = ref.watch(questionProvider);
    final index = ref.watch(currentIndexProvider);

    return questionsAsyncValue.when(
      data: (questions) {
        // Data is available, display the progress
        if (questions.isEmpty) {
          return const SizedBox.shrink(); // Or show a message like "No questions"
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${index + 1} / ${questions.length}',
              style: isTablet ? theme.titleLarge : theme.titleMedium,
            ),
            SizedBox(height: gap),
            LinearProgressIndicator(
              value: (index + 1) / questions.length,
              minHeight: 10,
              backgroundColor: Colors.grey.withValues(alpha: 0.4),
            ),
          ],
        );
      },
      loading: () =>
          const SizedBox.shrink(), // Or show a smaller loading indicator
      error: (err, st) => const SizedBox.shrink(), // Or show an error state
    );
  }
}
