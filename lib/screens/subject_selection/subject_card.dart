import 'package:flutter/material.dart';
import '../../models/subject.dart';
import 'quiz_format_selection.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({super.key, required this.subject});
  final Subject subject;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    final theme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        // navigate to quiz format selection
        showModalBottomSheet(
          context: context,
          builder: (ctx) => QuizFormatSelection(subject.name),
        );
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(subject.icon, size: isTablet ? 32.0 : 24.0),
            SizedBox(height: isTablet ? 16.0 : 8.0),
            //
            Text(
              subject.name,
              style: isTablet ? theme.titleLarge : theme.titleMedium,
            ),
            SizedBox(height: isTablet ? 16.0 : 8.0),
            Text(
              subject.description,
              style: (isTablet ? theme.titleMedium : theme.bodyMedium)!
                  .copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
