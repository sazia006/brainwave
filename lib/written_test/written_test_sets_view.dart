import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'submit_written_test_view.dart';

class WrittenTestSetsView extends StatelessWidget {
  const WrittenTestSetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          /// Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B7CFF), Color(0xFF7B4CFF)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Written Test",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  "Select a practice set",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _WrittenSetCard(
                  title: "Chemistry Practical - Set 1",
                  subject: "Chemistry",
                  questions: "5 Questions",
                  time: "60 mins",
                  completed: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubmitWrittenTestView(),
                      ),
                    );
                  },
                ),
                _WrittenSetCard(
                  title: "Physics Problem Solving",
                  subject: "Physics",
                  questions: "8 Questions",
                  time: "80 mins",
                  completed: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WrittenSetCard extends StatelessWidget {
  final String title;
  final String subject;
  final String questions;
  final String time;
  final bool completed;
  final VoidCallback onTap;

  const _WrittenSetCard({
    required this.title,
    required this.subject,
    required this.questions,
    required this.time,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject, style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.description, size: 16),
                const SizedBox(width: 6),
                Text(questions),
                const SizedBox(width: 14),
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 6),
                Text(time),
              ],
            ),
            if (completed)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Completed",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
