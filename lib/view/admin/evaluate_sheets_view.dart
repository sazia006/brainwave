import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'evaluation_detail_view.dart'; // Import Detail View
import 'widgets/data_table_card.dart';

class EvaluateSheetsView extends StatelessWidget {
  const EvaluateSheetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('written_submissions')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No pending evaluations"));
          }

          return DataTableCard(
            headers: const ["Student", "Exam", "Submitted", "Action"],
            rows: docs.map((doc) {
              final d = doc.data() as Map<String, dynamic>;
              return [
                Text(d['studentName'] ?? 'Unknown'),
                Text(d['examTitle'] ?? d['testTitle'] ?? 'Unknown'),
                Text(
                  (d['submittedAt'] as Timestamp?)?.toDate().toString().split(
                        ' ',
                      )[0] ??
                      '-',
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Navigate to Detail View with Submission ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EvaluationDetailView(submissionId: doc.id, data: d),
                      ),
                    );
                  },
                  child: const Text("Evaluate"),
                ),
              ];
            }).toList(),
          );
        },
      ),
    );
  }
}
