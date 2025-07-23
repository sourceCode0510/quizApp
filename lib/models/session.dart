class Session {
  final String id;
  final String name;
  final DateTime createdAt;
  final int correctAnswers;
  final int incorrectAnswers;
  final int skippedAnswers;
  final double score;

  Session({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.skippedAnswers,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'skippedAnswers': skippedAnswers,
      'score': score,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
      correctAnswers: map['correctAnswers'],
      incorrectAnswers: map['incorrectAnswers'],
      skippedAnswers: map['skippedAnswers'],
      score: map['score'],
    );
  }
}
