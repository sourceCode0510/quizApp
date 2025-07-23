import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/subject.dart';
import '../models/question.dart';
import '../models/session.dart';
import 'dart:developer' as dev;

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE subjects(
        name TEXT NOT NULL PRIMARY KEY,
        description TEXT NOT NULL,
        questionsCount INTEGER NOT NULL,
        iconCodePoint INTEGER NOT NULL,
        iconFontFamily TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE questions(
        id TEXT PRIMARY KEY ,
        subjectName TEXT NOT NULL,
        questionText TEXT NOT NULL,
        answer TEXT NOT NULL,
        options TEXT NOT NULL,
        explanation TEXT NOT NULL,
        FOREIGN KEY(subjectName) REFERENCES subjects(name)
      )
    ''');
    // automatically update the questionscount of subjects when new questions are uploaded or deleted
    await db.execute('''
      CREATE TRIGGER update_questions_count
      AFTER INSERT ON questions
      BEGIN
        UPDATE subjects
        SET questionsCount = (
          SELECT COUNT(*)
          FROM questions
          WHERE subjectName = NEW.subjectName
        )
        WHERE name = NEW.subjectName;
      END;
    ''');
    await db.execute('''
      CREATE TRIGGER delete_questions
      AFTER DELETE ON questions
      BEGIN
        UPDATE subjects
        SET questionsCount = (
          SELECT COUNT(*)
          FROM questions
          WHERE subjectName = OLD.subjectName
        )
        WHERE name = OLD.subjectName;
      END;
    ''');

    await db.execute('''
      CREATE TABLE sessions(
        id TEXT PRIMARY KEY ,
        name TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        correctAnswers INTEGER NOT NULL,
        incorrectAnswers INTEGER NOT NULL,
        skippedAnswers INTEGER NOT NULL,
        score REAL NOT NULL,
        FOREIGN KEY(name) REFERENCES subjects(name)
      )
    ''');
  }

  Future<void> uploadSubjects(List<Map<String, dynamic>> subjects) async {
    final db = await instance.database;
    try {
      final batch = db.batch();
      for (final subject in subjects) {
        batch.insert('subjects', Subject.fromMap(subject).toMap());
      }
      final result = await batch.commit();
      dev.log('Subjects uploaded: $result');
    } catch (e) {
      dev.log('Error uploading subjects: $e');
      throw Exception('Error uploading subjects: $e');
    }
  }

  Future<List<Subject>> getSubjects() async {
    final db = await instance.database;
    try {
      final subjects = await db.query('subjects');
      return subjects.map((subject) => Subject.fromMap(subject)).toList();
    } catch (e) {
      dev.log('Error getting subjects: $e');
      throw Exception('Error getting subjects: $e');
    }
  }

  Future<void> uploadQuestions(List<Map<String, dynamic>> questions) async {
    final db = await instance.database;
    try {
      final batch = db.batch();
      for (final question in questions) {
        batch.insert('questions', Question.fromMap(question).toMap());
      }
      final result = await batch.commit();
      dev.log('Questions uploaded: $result');
    } catch (e) {
      dev.log('Error uploading questions: $e');
      throw Exception('Error uploading questions: $e');
    }
  }

  Future<List<Question>> getQuestions(
    String subjectName,
    int questionsCount,
  ) async {
    final db = await instance.database;
    try {
      final questions = await db.query(
        'questions',
        where: 'subjectName = ?',
        whereArgs: [subjectName],
        limit: questionsCount,
        orderBy: 'RANDOM()',
      );

      return questions.map((question) => Question.fromMap(question)).toList();
    } catch (e) {
      dev.log('Error getting questions: $e');
      throw Exception('Error getting questions: $e');
    }
  }

  Future<void> addSession(Session session) async {
    final db = await instance.database;
    try {
      await db.insert('sessions', session.toMap());
      dev.log('Session added: $session');
    } catch (e) {
      dev.log('Error adding session: $e');
      throw Exception('Error adding session: $e');
    }
  }
}
