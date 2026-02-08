import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class ResultView extends StatelessWidget {
  final List<QuestionResult> results;

  const ResultView({super.key, required this.results});

  double get score {
    double s = 0;
    for (var q in results) {
      if (q.userAnswer == null) continue; // Skipped = 0 marks
      if (q.userAnswer == q.correctAnswer) {
        s += 1; // Correct
      } else {
        s -= 0.25; // Wrong
      }
    }
    return s;
  }

  String performanceMessage() {
    final percent = (score / results.length) * 100;
    if (percent < 40) return "Practice more 💪";
    if (percent < 70) return "Good progress 👍";
    return "Excellent job 🎉";
  }

  @override
  Widget build(BuildContext context) {
    final correct = results
        .where((q) => q.userAnswer == q.correctAnswer)
        .length;
    final wrong = results
        .where((q) => q.userAnswer != null && q.userAnswer != q.correctAnswer)
        .length;
    final skipped = results.where((q) => q.userAnswer == null).length;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              children: [
                const Text(
                  "Quiz Completed",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text(
                  "${score.toStringAsFixed(2)} pts",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  performanceMessage(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat("Correct", correct, Colors.green),
              _stat("Wrong", wrong, Colors.red),
              _stat("Skipped", skipped, Colors.blue),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (_, i) {
                final q = results[i];
                final isCorrect = q.userAnswer == q.correctAnswer;
                final isSkipped = q.userAnswer == null;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.black.withOpacity(.05),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Q${i + 1}. ${q.question}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      if (!isSkipped)
                        Row(
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Your answer: ${q.userAnswer}",
                                style: TextStyle(
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          "You skipped this question",
                          style: TextStyle(color: Colors.orange),
                        ),

                      const SizedBox(height: 6),
                      Text(
                        "Correct answer: ${q.correctAnswer}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const Text(
                        "Solution:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .teal, // Updated to standard color if AppColors.darkGreen missing
                        ),
                      ),
                      Text(q.solution),
                    ],
                  ),
                );
              },
            ),
          ),

          // Added a button to close the result view
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF4B2B),
                  side: const BorderSide(color: Color(0xFFFF4B2B)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Back to Home"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class QuestionResult {
  final String question;
  final String correctAnswer;
  final String? userAnswer;
  final String solution;

  QuestionResult({
    required this.question,
    required this.correctAnswer,
    this.userAnswer,
    required this.solution,
  });
}
