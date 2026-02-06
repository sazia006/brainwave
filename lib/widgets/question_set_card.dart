import 'package:flutter/material.dart';
import '../view/test/test_view.dart';

class QuestionSetCard extends StatelessWidget {
  final String title;
  final String subject;
  final String questions;
  final String date;
  final String status;
  final Color statusColor;
  final bool showScore;
  final String score;

  const QuestionSetCard({
    super.key,
    required this.title,
    required this.subject,
    required this.questions,
    required this.date,
    required this.status,
    required this.statusColor,
    this.showScore = false,
    this.score = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(.05)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(subject, style: const TextStyle(color: Colors.purple)),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.description, size: 16),
              const SizedBox(width: 6),
              Text(questions),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 6),
              Text(date),
            ],
          ),

          if (showScore) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Score:"),
                Text(
                  score,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TestView()),
                );
              },
              child: const Text("View Details"),
            ),
          ),
        ],
      ),
    );
  }
}
