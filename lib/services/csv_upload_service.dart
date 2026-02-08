import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';

class CsvUploadService {
  static Future<int> uploadCsv(
    Uint8List fileBytes,
    String selectedSetId,
  ) async {
    // 1. Decode the file
    final csvString = utf8.decode(fileBytes);

    // 2. Convert CSV to List of Lists
    final List<List<dynamic>> rows = const CsvToListConverter().convert(
      csvString,
      eol: '\n',
      shouldParseNumbers: false, // Keep everything as Text to avoid errors
    );

    if (rows.isEmpty) return 0;

    // 3. Remove Header Row
    final dataRows = rows.skip(1).toList();

    final firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    int count = 0;
    int batchCount = 0;

    for (var row in dataRows) {
      // Safety Check: Ensure row has at least 10 columns
      if (row.length < 10) continue;

      final docRef = firestore.collection('questions').doc();

      // 4. THE MAPPING MAGIC
      // We take your separate columns (A, B, C, D) and combine them
      // into a single list 'options' for the App to use.

      batch.set(docRef, {
        'setId': selectedSetId, // Use the ID from your Dropdown
        'question': row[3].toString().trim(),
        'options': [
          row[4].toString().trim(), // Option A
          row[5].toString().trim(), // Option B
          row[6].toString().trim(), // Option C
          row[7].toString().trim(), // Option D
        ],
        'correctAnswer': row[8].toString().trim(),
        'explanation': row[9].toString().trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      count++;
      batchCount++;

      // 5. Commit in batches of 450 (Firestore limit is 500)
      if (batchCount >= 450) {
        await batch.commit();
        batch = firestore.batch();
        batchCount = 0;
      }
    }

    // Commit final batch
    if (batchCount > 0) {
      await batch.commit();
    }

    // 6. Update Practice Set Total Count
    await firestore.collection('practice_sets').doc(selectedSetId).update({
      'totalQuestions': FieldValue.increment(count),
    });

    return count;
  }
}
