import 'package:flutter/material.dart';
import '../../viewmodel/practice_viewmodel.dart';
import '../../widgets/question_set_card.dart';
import '../../core/app_colors.dart';

class EasySetsView extends StatefulWidget {
  const EasySetsView({super.key});

  @override
  State<EasySetsView> createState() => _EasySetsViewState();
}

class _EasySetsViewState extends State<EasySetsView> {
  // 1. Instantiate the ViewModel
  final PracticeViewModel _viewModel = PracticeViewModel();

  @override
  void initState() {
    super.initState();
    // 2. Fetch "easy" sets when the screen loads
    _viewModel.fetchSets("easy");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Easy Sets")),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          // 3. Handle Loading State
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.softGreen),
            );
          }

          // 4. Handle Empty State
          if (_viewModel.sets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 48, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No easy practice sets available yet."),
                ],
              ),
            );
          }

          // 5. Render List of Sets
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _viewModel.sets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final set = _viewModel.sets[index];

              // Decide which question count to show (Limit vs Total Pool)
              final int qCount =
                  set['questionsPerExam'] ?? set['totalQuestions'] ?? 0;

              return QuestionSetCard(
                // ✅ Pass ID so the card can navigate to the Test
                id: set['id'],
                title: set['title'] ?? "Untitled Set",
                subject: set['subject'] ?? "General",
                questions: "$qCount Questions",
                date: "${set['duration'] ?? 30} mins",
                status: "Start",
                statusColor: Colors.green,
                showScore: false, // Hide score until we implement history
              );
            },
          );
        },
      ),
    );
  }
}
