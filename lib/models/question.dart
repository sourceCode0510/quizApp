class Question {
  final String id;
  final String subjectName;
  final String questionText;
  final List<String> options;
  final String answer;
  final String explanation;
  final bool isSelected;
  final String selectedOption;

  Question({
    required this.id,
    required this.subjectName,
    required this.questionText,
    required this.options,
    required this.answer,
    required this.explanation,
    this.isSelected = false,
    this.selectedOption = '',
  });

  Question copyWith({bool? isSelected, String? selectedOption}) => Question(
    id: id,
    subjectName: subjectName,
    questionText: questionText,
    options: options,
    answer: answer,
    explanation: explanation,
    isSelected: isSelected ?? this.isSelected,
    selectedOption: selectedOption ?? this.selectedOption,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectName': subjectName,
      'questionText': questionText,
      'options': options.join('|'),
      'answer': answer,
      'explanation': explanation,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'].toString(),
      subjectName: map['subjectName'],
      questionText: map['questionText'],
      options: map['options'].split('|').toList(),
      answer: map['answer'],
      explanation: map['explanation'],
    );
  }
}
