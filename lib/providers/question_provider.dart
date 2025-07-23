import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import '../services/database_service.dart';
import 'db_provider.dart';
import 'dart:developer' as dev;

final currentIndexProvider = StateProvider<int>((ref) => 0);

final questionProvider =
    StateNotifierProvider<QuestionNotifier, AsyncValue<List<Question>>>(
      (ref) => QuestionNotifier(ref),
    );

class QuestionNotifier extends StateNotifier<AsyncValue<List<Question>>> {
  QuestionNotifier(this._ref) : super(AsyncValue.loading());

  final Ref _ref;
  DatabaseService get _db => _ref.read(dbProvider);

  Future<void> loadQuestions({
    required String subjectName,
    required int questionsCount,
  }) async {
    try {
      final questions = await _db.getQuestions(subjectName, questionsCount);
      state = AsyncValue.data(questions);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      dev.log('Error loading questions: $e');
    }
  }

  Future<void> uploadQuestions(List<Map<String, dynamic>> questions) async {
    try {
      await _db.uploadQuestions(questions);
    } catch (e) {
      dev.log('Error uploading questions: $e');
    }
  }

  Question get currentQuestion {
    final questions = state.value;
    if (questions != null && questions.isNotEmpty) {
      final index = _ref.read(currentIndexProvider);
      return questions[index];
    } else {
      throw Exception('No questions available');
    }
  }

  void selectOption(String option) async {
    try {
      final questions = state.value;
      if (questions == null || questions.isEmpty) {
        throw Exception('No questions available');
      }
      questions[_ref.read(currentIndexProvider)] = currentQuestion.copyWith(
        isSelected: true,
        selectedOption: option,
      );
      state = AsyncValue.data(questions);
    } catch (e) {
      dev.log('Error selecting option: $e');
    }
  }

  void nextQuestion() {
    final index = _ref.read(currentIndexProvider);
    if (index < state.value!.length - 1) {
      _ref.read(currentIndexProvider.notifier).state = index + 1;
    }
  }

  void previousQuestion() {
    final index = _ref.read(currentIndexProvider);
    if (index > 0) {
      _ref.read(currentIndexProvider.notifier).state = index - 1;
    }
  }

  void reset() {
    _ref.read(currentIndexProvider.notifier).state = 0;
    state = AsyncValue.data([]);
  }
}
