import 'package:flutter/material.dart';
import '../../viewmodel/practice_viewmodel.dart';
import '../../widgets/question_set_card.dart';
import '../../core/app_colors.dart';

class HardSetsView extends StatefulWidget {
  const HardSetsView({super.key});

  @override
  State<HardSetsView> createState() => _HardSetsViewState();
}

class _HardSetsViewState extends State<HardSetsView> {
  // 1. Instantiate ViewModel
  final PracticeViewModel _viewModel = PracticeViewModel();

  @override
  void initState() {
    super.initState();
    // 2. Fetch "hard" sets
    _viewModel.fetchSets("hard");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hard Sets")),
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
                  Icon(Icons.lock_clock, size: 48, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No hard practice sets available."),
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
                id: set['id'], // Pass ID for navigation
                title: set['title'] ?? "Untitled Set",
                subject: set['subject'] ?? "General",
                questions: "$qCount Questions",
                date: "${set['duration'] ?? 30} mins",
                status: "Start",
                statusColor: Colors.red, // Red theme for Hard
              );
            },
          );
        },
      ),
    );
  }
}
