import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluationDetailView extends StatefulWidget {
  final String submissionId;
  final Map<String, dynamic> data;

  const EvaluationDetailView({
    super.key,
    required this.submissionId,
    required this.data,
  });

  @override
  State<EvaluationDetailView> createState() => _EvaluationDetailViewState();
}

class _EvaluationDetailViewState extends State<EvaluationDetailView> {
  final Map<int, TextEditingController> _controllers = {};
  bool _isSaving = false;

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submitEvaluation(List<dynamic> answers) async {
    setState(() => _isSaving = true);

    double totalMarks = 0;

    for (int i = 0; i < answers.length; i++) {
      double marks = double.tryParse(_controllers[i]?.text ?? "0") ?? 0;
      totalMarks += marks;
    }

    try {
      await FirebaseFirestore.instance
          .collection('written_submissions')
          .doc(widget.submissionId)
          .update({
            'status': 'evaluated',
            'marksObtained': totalMarks,
            'evaluatedAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Evaluation Saved Successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error saving: $e")));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> answers = widget.data['answers'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: Text("Evaluating: ${widget.data['studentName']}"),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          else
            TextButton.icon(
              icon: const Icon(Icons.check_circle, color: Colors.blue),
              label: const Text(
                "Submit Evaluation",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => _submitEvaluation(answers),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (_, i) {
                  final answer = answers[i];
                  _controllers.putIfAbsent(i, () => TextEditingController());

                  return Card(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Question ${i + 1}: ${answer['question'] ?? 'No Text'}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: answer['answerUrl'] != null
                                ? Image.network(
                                    answer['answerUrl'],
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Text("Image Failed to Load"),
                                    ),
                                  )
                                : const Center(
                                    child: Text("No Image Uploaded"),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _controllers[i],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Marks for this answer",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.score),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Exam Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text("Exam: ${widget.data['examTitle']}"),
                      const SizedBox(height: 8),
                      Text("Total Questions: ${answers.length}"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
