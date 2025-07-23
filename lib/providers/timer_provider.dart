import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';

final timeLimitProvider = StateProvider<Duration>(
  (ref) => const Duration(minutes: 5),
);
final quizTimerProvider = StateNotifierProvider<QuizTimerNotifier, Duration>(
  (ref) => QuizTimerNotifier(ref),
);

final quizEndedProvider = StateProvider<bool>((ref) => false);

class QuizTimerNotifier extends StateNotifier<Duration> {
  QuizTimerNotifier(this.ref) : super(Duration.zero);

  final Ref ref;
  Timer? _timer;

  void start() {
    final totalTime = ref.read(timeLimitProvider);
    state = totalTime;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.inSeconds <= 1) {
        timer.cancel();
        state = Duration.zero;

        // Notify quiz end
        ref.read(quizEndedProvider.notifier).state = true;
      } else {
        state = Duration(seconds: state.inSeconds - 1);
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void reset() {
    stop();
    state = ref.read(timeLimitProvider);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
