import '../../providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptionList extends ConsumerWidget {
  const OptionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsyncValue = ref.watch(
      questionProvider,
    ); // Watch the AsyncValue

    return questionsAsyncValue.when(
      data: (questions) {
        // Data is available, display the list
        if (questions.isEmpty) {
          return const Center(child: Text('No questions loaded.'));
        }

        final questionIndex = ref.watch(currentIndexProvider);

        final question = questions[questionIndex];
        bool isSelected = question.isSelected;

        return ListView.builder(
          itemCount: question.options.length,
          itemBuilder: (ctx, i) {
            final option = question.options[i];
            // Pass `question.selectedOption` to OptionCard to highlight the chosen one
            return OptionCard(
              option: option,
              isEnabled:
                  !isSelected, // Options are enabled only if no selection has been made
              isSelectedOption:
                  question.selectedOption ==
                  option, // Pass whether this specific option is selected
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ), // Show loading indicator
      error: (err, st) =>
          Center(child: Text('Error: ${err.toString()}')), // Show error message
    );
  }
}

// --- OptionCard modifications ---
class OptionCard extends ConsumerWidget {
  const OptionCard({
    super.key,
    required this.option,
    required this.isEnabled,
    required this.isSelectedOption, // New property
  });
  final String option;
  final bool isEnabled;
  final bool isSelectedOption; // New property

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    final theme = Theme.of(context);

    return ListTile(
      onTap: isEnabled
          ? () {
              ref
                  .read(questionProvider.notifier)
                  .selectOption(option); // Call without WidgetRef
            }
          : null,
      // Use isSelectedOption directly for tileColor
      tileColor: isSelectedOption ? theme.colorScheme.primary : null,
      title: Text(
        option,
        style: isTablet
            ? theme.textTheme.bodyLarge
            : theme.textTheme.bodyMedium,
      ),
    );
  }
}
