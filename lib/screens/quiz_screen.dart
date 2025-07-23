import 'package:flutter/material.dart';
import 'quiz_screen/timer_strip.dart';
import 'quiz_screen/question_progress_indicator.dart';
import 'quiz_screen/question_text.dart';
import 'quiz_screen/option_list.dart';
import 'quiz_screen/question_controllers.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});
  static const name = '/quiz_screen';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? 32.0 : 16.0;
    final gap = isTablet ? 30.0 : 20.0;

    final topFlex = isTablet ? 50 : 40;
    final bottomFlex = isTablet ? 50 : 60;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          padding.top + padding.bottom,
          horizontalPadding,
          padding.bottom,
        ),
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            TimerStrip(),
            SizedBox(height: gap),
            QuestionProgressIndicator(),
            SizedBox(height: gap),
            Expanded(flex: topFlex, child: QuestionText()),
            const Divider(),
            Expanded(flex: bottomFlex, child: OptionList()),
            QuestionControllers(),
          ],
        ),
      ),
    );
  }
}
