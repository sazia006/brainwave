import 'package:flutter/material.dart';
import '../../viewmodel/practice_viewmodel.dart';
import '../../widgets/question_set_card.dart';
import '../../core/app_colors.dart';
import '../test/test_view.dart'; // ✅ Import TestView

class MediumSetsView extends StatefulWidget {
  const MediumSetsView({super.key});

  @override
  State<MediumSetsView> createState() => _MediumSetsViewState();
}

class _MediumSetsViewState extends State<MediumSetsView> {
  final PracticeViewModel _viewModel = PracticeViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchSets("medium");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medium Sets")),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.softGreen),
            );
          }

          if (_viewModel.sets.isEmpty) {
            return const Center(
              child: Text("No easy practice sets available."),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _viewModel.sets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final set = _viewModel.sets[index];
              final int qCount =
                  set['questionsPerExam'] ?? set['totalQuestions'] ?? 0;

              // ✅ WRAP WITH GESTURE DETECTOR
              return GestureDetector(
                onTap: () {
                  // Navigate to TestView with the Set ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TestView(
                        setId: set['id'],
                        title: set['title'] ?? "Test",
                      ),
                    ),
                  );
                },
                child: QuestionSetCard(
                  id: set['id'],
                  title: set['title'] ?? "Untitled Set",
                  subject: set['subject'] ?? "General",
                  questions: "$qCount Questions",
                  date: "${set['duration'] ?? 30} mins",
                  status: "Start",
                  statusColor: Colors.green,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
