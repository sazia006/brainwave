import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SubmitWrittenTestView extends StatefulWidget {
  // ✅ 1. These fields allow data to be passed from the previous screen
  final String setTitle;
  final String subject;
  final List<String> questions;

  const SubmitWrittenTestView({
    super.key,
    required this.setTitle,
    required this.subject,
    required this.questions,
  });

  @override
  State<SubmitWrittenTestView> createState() => _SubmitWrittenTestViewState();
}

class _SubmitWrittenTestViewState extends State<SubmitWrittenTestView> {
  // Map to store images for each question index
  final Map<int, File?> _answerImages = {};
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _answerImages[index] = File(pickedFile.path);
      });
    }
  }

  void _showPickerOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(index, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(index, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          /// ===== HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B7CFF), Color(0xFF7B4CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Submit Answer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.subject} • ${widget.setTitle}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ===== CONTENT =====
          Expanded(
            child: widget.questions.isEmpty
                ? const Center(child: Text("No questions found."))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount:
                        widget.questions.length + 1, // +1 for Instruction Card
                    itemBuilder: (context, index) {
                      // Last item is the Instruction Card
                      if (index == widget.questions.length) {
                        return const _InstructionCard();
                      }

                      return _QuestionUploadCard(
                        index: index + 1,
                        question: widget.questions[index],
                        image: _answerImages[index],
                        onTapUpload: () => _showPickerOptions(index),
                        onTapRemove: () =>
                            setState(() => _answerImages.remove(index)),
                      );
                    },
                  ),
          ),
        ],
      ),

      /// ===== SUBMIT BUTTON =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_answerImages.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please upload at least one answer."),
                ),
              );
              return;
            }
            // Add your Firebase Upload Logic here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Submitting answers...")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B7CFF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
          child: const Text(
            "Submit Test",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS ---

class _QuestionUploadCard extends StatelessWidget {
  final int index;
  final String question;
  final File? image;
  final VoidCallback onTapUpload;
  final VoidCallback onTapRemove;

  const _QuestionUploadCard({
    required this.index,
    required this.question,
    required this.image,
    required this.onTapUpload,
    required this.onTapRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B7CFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Q$index",
                    style: const TextStyle(
                      color: Color(0xFF5B7CFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Upload Area
          image == null
              ? InkWell(
                  onTap: onTapUpload,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: const Color(0xFFF9FAFC),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tap to upload answer",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Image.file(
                      image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: onTapRemove,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light Amber
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFFFFA000)),
              SizedBox(width: 10),
              Text(
                "Instructions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFA000),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text("• Ensure your handwriting is legible."),
          Text("• Images should be clear and well-lit."),
          Text("• You can upload only one image per question."),
          Text("• Click submit only after reviewing all answers."),
        ],
      ),
    );
  }
}
