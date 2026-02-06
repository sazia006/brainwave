import 'package:flutter/material.dart';
import '../../widgets/question_set_card.dart';

class HardSetsView extends StatelessWidget {
  const HardSetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hard Sets")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          QuestionSetCard(
            title: "Advanced Physics - Set 1",
            subject: "Physics",
            questions: "15 Questions",
            date: "2026-02-05",
            status: "Locked",
            statusColor: Colors.red,
          ),
          QuestionSetCard(
            title: "Organic Chemistry - Set 2",
            subject: "Chemistry",
            questions: "14 Questions",
            date: "2026-02-04",
            status: "Available",
            statusColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
