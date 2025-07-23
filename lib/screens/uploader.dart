import 'package:flutter/material.dart';
import 'uploader/upload_container.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subject_provider.dart';
import '../providers/question_provider.dart';

class Uploader extends ConsumerStatefulWidget {
  const Uploader({super.key});
  static const name = '/uploader_screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploaderState();
}

enum UploadType { subjects, questions }

class _UploaderState extends ConsumerState<Uploader> {
  String _subjectData = '';
  String _questionData = '';
  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> _questions = [];

  _pickFile(UploadType type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      final data = await file.readAsString();
      final converted = List<Map<String, dynamic>>.from(jsonDecode(data));
      dev.log('Converted: $converted');
      if (type == UploadType.subjects) {
        setState(() {
          _subjectData = converted.toString();
          _subjects = converted;
        });
      } else {
        setState(() {
          _questionData = converted.toString();
          _questions = converted;
        });
      }
    }
  }

  _addToDb(UploadType type) {
    if (type == UploadType.subjects) {
      ref.read(subjectProvider.notifier).uploadSubjects(_subjects);
    } else {
      ref.read(questionProvider.notifier).uploadQuestions(_questions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? 32.0 : 16.0;
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
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
            const SizedBox(height: 30.0),
            UploadContainer(
              onUpload: () => _pickFile(UploadType.subjects),
              text: _subjectData,
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _addToDb(UploadType.subjects),
              child: const Text('Upload Subjects'),
            ),
            const SizedBox(height: 30.0),
            UploadContainer(
              onUpload: () => _pickFile(UploadType.questions),
              text: _questionData,
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _addToDb(UploadType.questions),
              child: const Text('Upload Questions'),
            ),
          ],
        ),
      ),
    );
  }
}
