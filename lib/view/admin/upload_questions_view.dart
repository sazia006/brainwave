import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import '../../services/csv_upload_service.dart';
import 'widgets/create_set_view.dart';
import 'widgets/csv_upload_box.dart';

class UploadQuestionsView extends StatefulWidget {
  const UploadQuestionsView({super.key});

  @override
  State<UploadQuestionsView> createState() => _UploadQuestionsViewState();
}

class _UploadQuestionsViewState extends State<UploadQuestionsView> {
  bool uploading = false;
  bool _isBulkSplitMode = false;

  // Single Mode
  String? _selectedSetId;

  // Bulk Mode
  String? _selectedDifficulty;
  String? _selectedSubject;
  final TextEditingController _questionsPerSetController =
      TextEditingController(text: "20");

  /// ==================================================
  /// 📂 MAIN PICK & UPLOAD FUNCTION
  /// ==================================================
  Future<void> pickCsv() async {
    // Validation
    if (_isBulkSplitMode) {
      if (_selectedDifficulty == null || _selectedSubject == null) {
        _showSnackBar("Please select Difficulty and Subject.", Colors.orange);
        return;
      }
    } else {
      if (_selectedSetId == null) {
        _showSnackBar("Please select a Practice Set first!", Colors.orange);
        return;
      }
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() => uploading = true);
        final fileBytes = result.files.single.bytes!;

        if (_isBulkSplitMode) {
          await _processBulkSplitUpload(fileBytes);
        } else {
          // You might need to update CsvUploadService too if it relies on hardcoded indices
          // But for now let's focus on the Bulk Split
          int count = await CsvUploadService.uploadCsv(
            fileBytes,
            _selectedSetId!,
          );
          _showSnackBar("Success! $count Questions uploaded.", Colors.green);
        }
      }
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    } finally {
      if (mounted) setState(() => uploading = false);
    }
  }

  /// ==================================================
  /// 🚀 SMART BULK SPLIT LOGIC (Updated for your CSV)
  /// ==================================================
  Future<void> _processBulkSplitUpload(List<int> bytes) async {
    try {
      final csvString = utf8.decode(bytes);
      List<List<dynamic>> rows = const CsvToListConverter().convert(csvString);

      if (rows.isEmpty) throw "CSV file is empty";

      // 1. MAP HEADERS TO INDICES
      // We look at the first row to find where everything is
      final headers = rows[0]
          .map((e) => e.toString().trim().toLowerCase())
          .toList();

      int idxQuestion = headers.indexOf('question');
      int idxOpA = headers.indexOf('optiona');
      int idxOpB = headers.indexOf('optionb');
      int idxOpC = headers.indexOf('optionc');
      int idxOpD = headers.indexOf('optiond');
      int idxCorrect = headers.indexOf('correctanswer');
      int idxExpl = headers.indexOf('explanation');

      // Validation: Ensure essential columns exist
      if (idxQuestion == -1 || idxOpA == -1 || idxCorrect == -1) {
        throw "CSV missing required columns: question, optionA, correctAnswer";
      }

      // Remove header row
      rows.removeAt(0);

      int chunkSize = int.tryParse(_questionsPerSetController.text) ?? 20;
      int setCounter = 1;
      final db = FirebaseFirestore.instance;
      int totalUploaded = 0;

      // 2. LOOP & CREATE SETS
      for (var i = 0; i < rows.length; i += chunkSize) {
        // Create Set
        DocumentReference newSetRef = db.collection('practice_sets').doc();
        String setTitle =
            "$_selectedSubject ${_selectedDifficulty!.toUpperCase()} Set $setCounter";

        await newSetRef.set({
          'title': setTitle,
          'subject': _selectedSubject,
          'difficulty': _selectedDifficulty,
          'duration': 30,
          'totalQuestions': 0, // Update later if needed
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Get Chunk
        int end = (i + chunkSize < rows.length) ? i + chunkSize : rows.length;
        List<List<dynamic>> chunk = rows.sublist(i, end);

        // Upload Questions
        final batch = db.batch();
        for (var row in chunk) {
          // Safety check: Row must be long enough to contain the max index we found
          // We use a helper function to safely get data
          String qText = _safeGet(row, idxQuestion);
          if (qText.isEmpty) continue; // Skip empty rows

          DocumentReference qRef = db.collection('questions').doc();
          batch.set(qRef, {
            'setId': newSetRef.id,
            'question': qText,
            'options': [
              _safeGet(row, idxOpA),
              _safeGet(row, idxOpB),
              _safeGet(row, idxOpC),
              _safeGet(row, idxOpD),
            ],
            'correctAnswer': _safeGet(row, idxCorrect),
            'explanation': idxExpl != -1 ? _safeGet(row, idxExpl) : "",
          });
        }
        await batch.commit();
        totalUploaded += chunk.length;
        setCounter++;
      }

      _showSnackBar(
        "Created ${setCounter - 1} sets with $totalUploaded questions!",
        Colors.green,
      );
    } catch (e) {
      print(e);
      _showSnackBar("Error: $e", Colors.red);
    }
  }

  // Helper to safely get data from row even if row length varies
  String _safeGet(List<dynamic> row, int index) {
    if (index >= 0 && index < row.length) {
      return row[index].toString().trim();
    }
    return "";
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  /// ==================================================
  /// 🎨 UI BUILD (Same as before)
  /// ==================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Upload Questions",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (!_isBulkSplitMode)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text("Create New Set"),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateSetView()),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text(
                  "Bulk Auto-Split Mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Automatically create multiple sets from one big file",
                ),
                value: _isBulkSplitMode,
                onChanged: (val) => setState(() => _isBulkSplitMode = val),
              ),
            ),
            const SizedBox(height: 20),

            // Config Inputs
            if (_isBulkSplitMode)
              _buildBulkModeInputs()
            else
              _buildSingleModeInputs(),

            const SizedBox(height: 30),

            // Upload Box
            Expanded(
              child: uploading
                  ? const Center(child: CircularProgressIndicator())
                  : CsvUploadBox(onPickFile: pickCsv),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkModeInputs() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedDifficulty,
            hint: const Text("Difficulty"),
            items: ["easy", "medium", "hard"]
                .map(
                  (e) =>
                      DropdownMenuItem(value: e, child: Text(e.toUpperCase())),
                )
                .toList(),
            onChanged: (val) => setState(() => _selectedDifficulty = val),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedSubject,
            hint: const Text("Subject"),
            items: [
              "Physics",
              "Chemistry",
              "Math",
              "Biology",
              "GK",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => _selectedSubject = val),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _questionsPerSetController,
            decoration: const InputDecoration(
              labelText: "Qty/Set",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleModeInputs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('practice_sets')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        final sets = snapshot.data!.docs;
        if (sets.isEmpty) return const Text("No Practice Sets found.");

        return DropdownButtonFormField<String>(
          isExpanded: true,
          value: _selectedSetId,
          hint: const Text("Choose a Set"),
          items: sets.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return DropdownMenuItem(
              value: doc.id,
              child: Text("${data['title']} • ${data['subject']}"),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedSetId = val),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
      },
    );
  }
}
