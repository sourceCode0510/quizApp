import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subject_provider.dart';
import 'subject_card.dart';

enum SubjectViewMode { list, grid }

class SubjectList extends ConsumerWidget {
  const SubjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width > 600;
    final asyncSubjects = ref.watch(subjectProvider);

    final gap = isTablet ? 24.0 : 12.0;
    return asyncSubjects.when(
      data: (subjects) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 4 : 2,
            crossAxisSpacing: gap,
            mainAxisSpacing: gap,
          ),
          itemCount: subjects.length,
          itemBuilder: (ctx, i) => SubjectCard(subject: subjects[i]),
        );
      },
      error: (e, st) => Center(child: Text(e.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
