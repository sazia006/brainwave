import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

class UploadWrittenQuestionsView extends StatefulWidget {
  const UploadWrittenQuestionsView({super.key});

  @override
  State<UploadWrittenQuestionsView> createState() =>
      _UploadWrittenQuestionsViewState();
}

class _UploadWrittenQuestionsViewState
    extends State<UploadWrittenQuestionsView> {
  // Form Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();

  // State for Questions List
  final List<String> _questions = [];
  bool _isUploading = false;

  // --- Logic: Add Single Question ---
  void _addQuestion() {
    if (_questionController.text.trim().isEmpty) return;
    setState(() {
      _questions.add(_questionController.text.trim());
      _questionController.clear();
    });
  }

  // --- Logic: Import from CSV ---
  Future<void> _importCsv() async {
    try {
      // 1. Pick File
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        // 2. Read File Content
        // Handling Web vs Mobile bytes
        final fileBytes = result.files.first.bytes;
        final path = result.files.first.path;

        String csvString;
        if (fileBytes != null) {
          csvString = utf8.decode(fileBytes);
        } else if (path != null) {
          csvString = await File(path).readAsString();
        } else {
          return;
        }

        // 3. Parse CSV
        List<List<dynamic>> rows = const CsvToListConverter().convert(
          csvString,
        );

        // 4. Extract Questions (Assuming 1st column is the question)
        int addedCount = 0;
        for (var i = 0; i < rows.length; i++) {
          // Skip header row if it says "Question"
          if (i == 0 &&
              rows[i][0].toString().toLowerCase().contains("question")) {
            continue;
          }

          String qText = rows[i][0].toString().trim();
          if (qText.isNotEmpty) {
            setState(() {
              _questions.add(qText);
            });
            addedCount++;
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Imported $addedCount questions successfully!"),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error reading CSV: $e")));
      }
    }
  }

  // --- Logic: Remove Question ---
  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  // --- Logic: Upload to Firestore ---
  Future<void> _uploadTest() async {
    if (_titleController.text.isEmpty ||
        _subjectController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and add questions."),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      await FirebaseFirestore.instance.collection('written_tests').add({
        'title': _titleController.text.trim(),
        'subject': _subjectController.text.trim(),
        'duration': int.tryParse(_durationController.text.trim()) ?? 60,
        'questions': _questions,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Written Test Uploaded Successfully!")),
        );
        _titleController.clear();
        _subjectController.clear();
        _durationController.clear();
        setState(() => _questions.clear());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error uploading: $e")));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Written Test",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // --- 1. Test Details ---
            _buildTextField(
              "Test Title",
              "e.g. Physics Midterm",
              _titleController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Subject",
                    "e.g. Physics",
                    _subjectController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    "Duration (mins)",
                    "e.g. 60",
                    _durationController,
                    isNumber: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // --- 2. Add Questions Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Questions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                // ✅ IMPORT CSV BUTTON
                TextButton.icon(
                  onPressed: _importCsv,
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Import CSV"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue[700],
                    backgroundColor: Colors.blue[50],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // --- Manual Add Input ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      hintText: "Type question manually...",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (_) => _addQuestion(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- 3. Questions List Preview ---
            if (_questions.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_questions.length} Questions Added",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _questions.clear()),
                          child: const Text(
                            "Clear All",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _questions.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(_questions[index]),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 18,
                            ),
                            onPressed: () => _removeQuestion(index),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "No questions added yet.\nUpload a CSV or add manually.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // --- 4. Submit Button ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Upload Test to Database",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
