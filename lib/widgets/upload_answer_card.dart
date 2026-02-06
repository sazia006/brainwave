import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadAnswerCard extends StatefulWidget {
  final String question;

  const UploadAnswerCard({super.key, required this.question});

  @override
  State<UploadAnswerCard> createState() => _UploadAnswerCardState();
}

class _UploadAnswerCardState extends State<UploadAnswerCard> {
  File? image;
  final picker = ImagePicker();

  Future pick(ImageSource source) async {
    final file = await picker.pickImage(source: source, imageQuality: 70);

    if (file != null) {
      setState(() => image = File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          GestureDetector(
            onTap: () => _showPicker(context),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(14),
              ),
              child: image == null
                  ? const Center(child: Text("Tap to upload image"))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(image!, fit: BoxFit.cover),
                    ),
            ),
          ),

          if (image != null)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => image = null),
              ),
            ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                pick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                pick(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
