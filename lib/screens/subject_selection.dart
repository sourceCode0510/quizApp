import 'package:flutter/material.dart';
import 'subject_selection/subject_list.dart';
import 'uploader.dart';

class SubjectSelection extends StatelessWidget {
  const SubjectSelection({super.key});
  static const name = '/subject_selection_screen';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? 32.0 : 16.0;
    final gap = isTablet ? 30.0 : 20.0;
    final textTheme = Theme.of(context).textTheme;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Uploader.name);
                  },
                  icon: const Icon(Icons.upload_file_outlined),
                ),
              ],
            ),
            SizedBox(height: gap),
            //
            Text('Welcome User', style: textTheme.headlineMedium),
            SizedBox(height: gap),
            Text(
              'What do you want to learn today?',
              style: textTheme.headlineSmall,
            ),
            SizedBox(height: gap),
            //
            Expanded(child: SubjectList()),
          ],
        ),
      ),
    );
  }
}
