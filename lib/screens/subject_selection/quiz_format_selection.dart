import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/question_provider.dart';
import '../quiz_screen.dart';
import '../../providers/timer_provider.dart';

final List<Map<String, dynamic>> quizFormatValues = [
  {'title': '01 Hour', 'questions': 30, 'timer': 60},
  {'title': '02 Hours', 'questions': 60, 'timer': 60 * 2},
  {'title': '03 Hours', 'questions': 100, 'timer': 60 * 3},
];

class QuizFormatSelection extends ConsumerWidget {
  const QuizFormatSelection(this.subjectName, {super.key});
  final String subjectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    final titleTheme = isTablet
        ? theme.textTheme.titleLarge
        : theme.textTheme.titleMedium;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Text('Select a quiz format', style: theme.textTheme.titleLarge),
          const SizedBox(height: 30.0),

          ...quizFormatValues.map(
            (format) => ListTile(
              onTap: () {
                ref
                    .read(questionProvider.notifier)
                    .loadQuestions(
                      subjectName: subjectName,
                      questionsCount: format['questions'],
                    );
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(QuizScreen.name);
                ref.read(timeLimitProvider.notifier).state = Duration(
                  minutes: format['timer'],
                );
                ref.read(quizTimerProvider.notifier).start();
              },
              title: Text(format['title'], style: titleTheme),
              trailing: Text(
                '${format['questions']} Questions',
                style: titleTheme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
