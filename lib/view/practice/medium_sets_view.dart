import 'package:flutter/material.dart';
import '../../widgets/question_set_card.dart';

class MediumSetsView extends StatelessWidget {
  const MediumSetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medium Sets")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          QuestionSetCard(
            title: "Chemistry Reactions - Set 1",
            subject: "Chemistry",
            questions: "12 Questions",
            date: "2026-02-08",
            status: "Completed",
            statusColor: Colors.green,
            showScore: true,
            score: "78/100",
          ),
          QuestionSetCard(
            title: "Algebra Practice - Set 2",
            subject: "Mathematics",
            questions: "10 Questions",
            date: "2026-02-07",
            status: "Available",
            statusColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
