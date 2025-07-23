import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upsc_quiz_app/providers/question_provider.dart';
import 'review_screen/review.dart';
import 'subject_selection.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});
  static const name = '/review_screen';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? 32.0 : 16.0;
    final theme = Theme.of(context);

    final asyncQuestions = ref.watch(questionProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            padding.top + padding.bottom,
            horizontalPadding,
            padding.bottom,
          ),
          width: size.width,
          child: asyncQuestions.when(
            data: (questions) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Question ${index + 1} / ${questions.length}',
                    style: isTablet
                        ? theme.textTheme.titleLarge
                        : theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 10.0),
                  LinearProgressIndicator(
                    value: (index + 1) / questions.length,
                    minHeight: 10,
                    backgroundColor: Colors.grey.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 20.0),
                  Expanded(
                    child: PageView.builder(
                      onPageChanged: (value) => {
                        setState(() {
                          index = value;
                        }),
                      },
                      itemCount: questions.length,
                      itemBuilder: (ctx, i) => Review(question: questions[i]),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        SubjectSelection.name,
                      ).then((_) {
                        ref.read(questionProvider.notifier).reset();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    child: Text(
                      'Go To Homepage',
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              );
            },
            error: (e, st) => Text(e.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
