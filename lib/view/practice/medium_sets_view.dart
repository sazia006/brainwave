import 'package:flutter/material.dart';
import '../../viewmodel/practice_viewmodel.dart';
import '../../widgets/question_set_card.dart';
import '../../core/app_colors.dart';

class MediumSetsView extends StatefulWidget {
  const MediumSetsView({super.key});

  @override
  State<MediumSetsView> createState() => _MediumSetsViewState();
}

class _MediumSetsViewState extends State<MediumSetsView> {
  // 1. Instantiate the ViewModel
  final PracticeViewModel _viewModel = PracticeViewModel();

  @override
  void initState() {
    super.initState();
    // 2. Fetch "medium" sets
    _viewModel.fetchSets("medium");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medium Sets")),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          // 3. Loading State
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.softGreen),
            );
          }

          // 4. Empty State
          if (_viewModel.sets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_graph, size: 48, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No medium practice sets available."),
                ],
              ),
            );
          }

          // 5. Render List
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _viewModel.sets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final set = _viewModel.sets[index];
              final int qCount =
                  set['questionsPerExam'] ?? set['totalQuestions'] ?? 0;

              return QuestionSetCard(
                id: set['id'], // ✅ Pass ID for navigation
                title: set['title'] ?? "Untitled Set",
                subject: set['subject'] ?? "General",
                questions: "$qCount Questions",
                date: "${set['duration'] ?? 30} mins",
                status: "Start",
                statusColor: Colors.blue, // Blue theme for Medium
              );
            },
          );
        },
      ),
    );
  }
}
