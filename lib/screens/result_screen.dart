import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/result_provider.dart';
import 'review_screen.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});
  static const name = '/result_screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? 32.0 : 16.0;
    final theme = Theme.of(context);
    final gap = isTablet ? 30.0 : 20.0;
    final greeting = isTablet
        ? theme.textTheme.headlineLarge
        : theme.textTheme.headlineMedium;

    final titles = isTablet
        ? theme.textTheme.headlineMedium
        : theme.textTheme.headlineSmall;

    final result = ref.watch(resultProvider);
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                Expanded(
                  child: Text(
                    'Quiz Results',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
              ],
            ),

            SizedBox(height: gap),

            Text(
              'Congratulations, User!',
              textAlign: TextAlign.center,
              style: greeting,
            ),
            SizedBox(height: gap),
            Text(
              'You have completed the quiz, here\'s a summary of your performance',
              textAlign: TextAlign.center,
              style: isTablet
                  ? theme.textTheme.titleLarge
                  : theme.textTheme.titleMedium,
            ),
            SizedBox(height: gap),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF454545),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score',
                    style: titles!.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '${result['score'].toStringAsFixed(2)}%',
                    style: titles.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            SizedBox(height: gap),
            MarksStrip(
              icon: Icons.check,
              title: 'Correct',
              marks: result['correct'].toString(),
            ),
            MarksStrip(
              icon: Icons.close,
              title: 'Incorrect',
              marks: result['incorrect'].toString(),
            ),
            MarksStrip(
              icon: Icons.info_outline,
              title: 'Skipped',
              marks: result['skipped'].toString(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ReviewScreen.name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                'Review Questions',
                style: TextStyle(color: theme.colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarksStrip extends StatelessWidget {
  const MarksStrip({
    super.key,
    required this.icon,
    required this.title,
    required this.marks,
  });
  final IconData icon;
  final String title;
  final String marks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    final titles = isTablet
        ? theme.textTheme.headlineMedium
        : theme.textTheme.headlineSmall;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
      leading: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: const Color(0xFF454545),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Icon(icon),
      ),
      title: Text(title, style: titles),
      trailing: Text(marks, style: titles),
    );
  }
}
