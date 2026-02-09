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
  // We need two controllers per question: one for Marks, one for Feedback
  final Map<int, TextEditingController> _markControllers = {};
  final Map<int, TextEditingController> _feedbackControllers = {}; // ✅ Added
  bool _isSaving = false;

  @override
  void dispose() {
    for (var c in _markControllers.values) {
      c.dispose();
    }
    for (var c in _feedbackControllers.values) {
      c.dispose();
    } // ✅ Dispose
    super.dispose();
  }

  Future<void> _submitEvaluation(List<dynamic> answers) async {
    setState(() => _isSaving = true);

    double totalObtained = 0;
    double maxTotal = 0;
    List<Map<String, dynamic>> feedbackList =
        []; // ✅ This is what the Result View needs

    // 1. Compile Data Loop
    for (int i = 0; i < answers.length; i++) {
      double marks = double.tryParse(_markControllers[i]?.text ?? "0") ?? 0;
      String feedback =
          _feedbackControllers[i]?.text.trim() ?? ""; // ✅ Get feedback
      if (feedback.isEmpty) feedback = "Evaluated";

      totalObtained += marks;
      maxTotal +=
          10; // Assuming 10 marks per question (or fetch from DB if available)

      // ✅ Build the breakdown list
      feedbackList.add({
        'question': answers[i]['question'] ?? "Question ${i + 1}",
        'score': marks.toInt(),
        'maxScore': 10,
        'feedback': feedback,
      });
    }

    try {
      // 2. Update Firestore with the structure WrittenTestResultView expects
      await FirebaseFirestore.instance
          .collection('written_submissions')
          .doc(widget.submissionId)
          .update({
            'status': 'evaluated',
            'score': totalObtained.toInt(), // Student app looks for 'score'
            'totalScore': maxTotal.toInt(),
            'feedbackList': feedbackList, // ✅ Save the list
            'evaluatorName': "Instructor", // Or fetch current admin name
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
    final List<dynamic> answers =
        widget.data['answers'] ??
        []; // Ensure your submission saves 'answers' as a list of maps, or strings.
    // If 'answers' in DB is just a list of Image URLs (strings), we might need to adjust how we get the Question Text.
    // Assuming 'answers' in DB is currently just Strings (URLs) based on your previous Student Submit code:
    // We will handle that below.

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: Text("Evaluating: ${widget.data['studentName'] ?? 'Student'}"),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircularProgressIndicator(),
              ),
            )
          else
            TextButton.icon(
              icon: const Icon(Icons.check_circle, color: Colors.blue),
              label: const Text(
                "Submit",
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
                  // Handle if answers are Maps (with question text) or just Strings (URLs)
                  // Let's assume the previous step saved them as Maps or we use a generic label
                  final answerData = answers[i];
                  String questionText = "Question ${i + 1}";
                  String? imageUrl;

                  if (answerData is Map) {
                    questionText = answerData['question'] ?? questionText;
                    imageUrl = answerData['answerUrl']; // or just 'url'
                  } else if (answerData is String) {
                    imageUrl = answerData; // It's just the URL
                  }

                  _markControllers.putIfAbsent(
                    i,
                    () => TextEditingController(),
                  );
                  _feedbackControllers.putIfAbsent(
                    i,
                    () => TextEditingController(),
                  ); // ✅ Init

                  return Card(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questionText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Answer Image
                          Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
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

                          // Grading Row
                          Row(
                            children: [
                              // Marks Input
                              SizedBox(
                                width: 150,
                                child: TextField(
                                  controller: _markControllers[i],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Marks (/10)",
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.score),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // ✅ Feedback Input
                              Expanded(
                                child: TextField(
                                  controller: _feedbackControllers[i],
                                  decoration: const InputDecoration(
                                    labelText: "Feedback / Remarks",
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.comment),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ... (Your Right Side Info Panel Code remains the same) ...
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
                      Text(
                        "Exam: ${widget.data['examTitle'] ?? widget.data['testTitle'] ?? 'Unknown'}",
                      ), // Check both fields
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
