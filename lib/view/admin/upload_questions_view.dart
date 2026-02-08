import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? _selectedSetId;

  Future<void> pickCsv() async {
    // 1. Validation
    if (_selectedSetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a Practice Set first!")),
      );
      return;
    }

    // 2. Pick File
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true, // ✅ CRITICAL: Ensures bytes are loaded
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() => uploading = true);

        // 3. Upload via Service
        int count = await CsvUploadService.uploadCsv(
          result.files.single.bytes!,
          _selectedSetId!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text("Success! $count Questions uploaded."),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => uploading = false);
    }
  }

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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text("Create New Set"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateSetView()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Dropdown Selector
            const Text(
              "Step 1: Select Practice Set",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('practice_sets')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LinearProgressIndicator();

                final sets = snapshot.data!.docs;

                if (sets.isEmpty) {
                  return const Text(
                    "No Practice Sets found. Create one above.",
                  );
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedSetId,
                      hint: const Text("Choose a Set to upload questions to"),
                      items: sets.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(
                            "${data['title']}  •  ${data['subject']}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedSetId = val),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Upload Area
            const Text(
              "Step 2: Upload CSV File",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: uploading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Parsing CSV and saving to Cloud..."),
                        ],
                      ),
                    )
                  : CsvUploadBox(onPickFile: pickCsv),
            ),
          ],
        ),
      ),
    );
  }
}
