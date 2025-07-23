import '../../providers/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/timer_provider.dart';

class TimerStrip extends ConsumerWidget {
  const TimerStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(quizTimerProvider);
    return Row(
      children: [
        Text(
          "${timer.inHours.remainder(60).toString().padLeft(2, '0')}:${timer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${timer.inSeconds.remainder(60).toString().padLeft(2, '0')}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            ref.read(questionProvider.notifier).reset();
            Navigator.pop(context);
          },
          child: Text(
            'Quit',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
