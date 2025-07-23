import 'package:flutter/material.dart';

class UploadContainer extends StatelessWidget {
  const UploadContainer({
    super.key,
    required this.text,
    required this.onUpload,
  });

  final String text;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onUpload,
      child: Container(
        constraints: BoxConstraints(maxHeight: 200.0),
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey),
        ),
        child: SingleChildScrollView(
          child: text != ''
              ? Text(text)
              : Column(
                  children: [
                    Icon(Icons.upload_file_outlined),
                    SizedBox(height: 16.0),
                    Text('Upload File'),
                  ],
                ),
        ),
      ),
    );
  }
}
