import 'package:flutter/material.dart';
import '../../models/question.dart';

class Review extends StatelessWidget {
  const Review({super.key, required this.question});
  final Question question;
  @override
  Widget build(BuildContext context) {
    final isCorrect = question.selectedOption == question.answer;
    final theme = Theme.of(context).textTheme;
    final isTablet = MediaQuery.sizeOf(context).width > 600;
    final style = isTablet ? theme.titleLarge : theme.titleMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question: ${question.questionText}',
          style: style!.copyWith(height: 1.5),
        ),
        Divider(height: 24.0),
        Text(
          'Your Answer: ${question.selectedOption} ${isCorrect ? '✅' : '❌'}',
          style: style.copyWith(height: 1.5),
        ),
        const SizedBox(height: 10.0),
        Text(
          'Correct Answer: ${question.answer}',
          style: style.copyWith(height: 1.5),
        ),
        Divider(height: 24.0),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              'Explanation: ${question.explanation}',
              style: style.copyWith(height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
