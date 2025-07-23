import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/subject_selection.dart';
import 'screens/quiz_screen.dart';
import 'screens/uploader.dart';
import 'screens/result_screen.dart';
import 'screens/review_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark().copyWith(primary: Colors.indigo),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: SubjectSelection.name,
      routes: {
        SubjectSelection.name: (context) => SubjectSelection(),
        QuizScreen.name: (context) => QuizScreen(),
        Uploader.name: (context) => Uploader(),
        ResultScreen.name: (context) => ResultScreen(),
        ReviewScreen.name: (context) => ReviewScreen(),
      },
    );
  }
}
