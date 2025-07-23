import 'dart:async';

import 'package:upsc_quiz_app/services/database_service.dart';

import '../models/subject.dart';
import 'db_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;

final subjectProvider =
    StateNotifierProvider<SubjectProvider, AsyncValue<List<Subject>>>(
      (ref) => SubjectProvider(ref),
    );

//
class SubjectProvider extends StateNotifier<AsyncValue<List<Subject>>> {
  SubjectProvider(this._ref) : super(AsyncValue.loading()) {
    _loadSubjects();
  }

  final Ref _ref;
  DatabaseService get _db => _ref.read(dbProvider);
  Future<void> _loadSubjects() async {
    try {
      state = AsyncValue.loading();
      final subjects = await _db.getSubjects();
      state = AsyncValue.data(subjects);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> uploadSubjects(List<Map<String, dynamic>> subjects) async {
    try {
      await _db.uploadSubjects(subjects);
    } catch (e) {
      dev.log('Error uploading subjects: $e');
    }
  }
}
