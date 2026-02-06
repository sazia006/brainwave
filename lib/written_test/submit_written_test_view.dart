import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/upload_answer_card.dart';

class SubmitWrittenTestView extends StatelessWidget {
  const SubmitWrittenTestView({super.key});

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
                  "Submit Answer",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  "Chemistry Practical - Set 1",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _InfoBox(),
                UploadAnswerCard(question: "Question 1: Define acidity."),
                UploadAnswerCard(question: "Question 2: Balance equation."),
                UploadAnswerCard(question: "Question 3: Explain reaction."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Subject: Chemistry"),
          Text("Questions: 5"),
          Text("Deadline: 2026-02-15"),
        ],
      ),
    );
  }
}
