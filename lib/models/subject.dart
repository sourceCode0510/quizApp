import 'package:flutter/material.dart';

class Subject {
  final String name;
  final String description;
  final int questionsCount;
  final IconData icon;

  Subject({
    required this.name,
    required this.description,
    required this.questionsCount,
    required this.icon,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'questionsCount': questionsCount,
    'iconCodePoint': icon.codePoint,
    'iconFontFamily': icon.fontFamily,
  };

  factory Subject.fromMap(Map<String, dynamic> map) => Subject(
    name: map['name'],
    description: map['description'],
    questionsCount: map['questionsCount'],
    icon: map['icon'] == null
        ? Icons.menu_book_outlined
        : IconData(map['iconCodePoint'], fontFamily: map['iconFontFamily']),
  );

  @override
  String toString() {
    return 'Subject(name: $name, description: $description, questionsCount: $questionsCount, icon: $icon)';
  }
}
