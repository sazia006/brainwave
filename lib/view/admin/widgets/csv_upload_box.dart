import 'package:flutter/material.dart';

class CsvUploadBox extends StatelessWidget {
  final VoidCallback onPickFile;

  const CsvUploadBox({super.key, required this.onPickFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.withOpacity(.4), width: 1.2),
      ),
      child: Column(
        children: [
          const Icon(Icons.upload_file, size: 60, color: Colors.blue),
          const SizedBox(height: 14),
          const Text(
            "Drag & drop CSV file here, or click to browse",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            "Supports CSV files with 30–40 questions per set",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onPickFile,
            icon: const Icon(Icons.folder_open),
            label: const Text("Choose CSV File"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
