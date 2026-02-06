import 'package:flutter/material.dart';
import '../../widgets/question_set_card.dart';

class EasySetsView extends StatelessWidget {
  const EasySetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Easy Sets")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          QuestionSetCard(
            title: "Mathematics Basics - Set 1",
            subject: "Mathematics",
            questions: "10 Questions",
            date: "2026-02-10",
            status: "Completed",
            statusColor: Colors.green,
            showScore: true,
            score: "85/100",
          ),
          QuestionSetCard(
            title: "Physics Fundamentals - Set 2",
            subject: "Physics",
            questions: "8 Questions",
            date: "2026-02-09",
            status: "Available",
            statusColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
