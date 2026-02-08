import 'package:flutter/material.dart';

class QuestionResult {
  final String question;
  final String correctAnswer;
  final String? userAnswer;
  final String solution;

  QuestionResult({
    required this.question,
    required this.correctAnswer,
    required this.userAnswer,
    required this.solution,
  });
}

class ResultView extends StatelessWidget {
  final List<QuestionResult> results;

  const ResultView({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    int correct = results.where((r) => r.userAnswer == r.correctAnswer).length;

    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: Column(
        children: [
          // Score Header
          Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            color: Colors.blue.shade50,
            child: Column(
              children: [
                const Text("You Scored", style: TextStyle(fontSize: 18)),
                Text(
                  "$correct / ${results.length}",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // Question Analysis
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final r = results[index];
                final isCorrect = r.userAnswer == r.correctAnswer;
                final isSkipped = r.userAnswer == null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q${index + 1}: ${r.question}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          "Your Answer: ${r.userAnswer ?? 'Skipped'}",
                          style: TextStyle(
                            color: isCorrect
                                ? Colors.green
                                : (isSkipped ? Colors.orange : Colors.red),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (!isCorrect)
                          Text(
                            "Correct Answer: ${r.correctAnswer}",
                            style: const TextStyle(color: Colors.green),
                          ),

                        const Divider(),
                        Text(
                          "Explanation: ${r.solution}",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Finish Review"),
            ),
          ),
        ],
      ),
    );
  }
}
