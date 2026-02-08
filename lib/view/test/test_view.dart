import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../viewmodel/test_viewmodel.dart';
import '../result/result_view.dart'; // ✅ Ensure this import works

class TestView extends StatefulWidget {
  final String setId;
  final String title;

  const TestView({super.key, required this.setId, required this.title});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final TestViewModel _viewModel = TestViewModel();
  int currentQuestionIndex = 0;
  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.loadTest(widget.setId).then((_) {
      startTimer(_viewModel.examDuration * 60);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer(int totalSeconds) {
    if (!mounted) return;
    setState(() => _secondsRemaining = totalSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        submitTest();
      }
    });
  }

  // ✅ SUBMIT LOGIC
  void submitTest() {
    _timer?.cancel();

    // Create Results List
    final results = List.generate(_viewModel.quizQuestions.length, (index) {
      final q = _viewModel.quizQuestions[index];
      return QuestionResult(
        question: q['question'] ?? "No Question Text",
        correctAnswer: q['correctAnswer'] ?? "",
        userAnswer: _viewModel.userAnswers[index], // Null if skipped
        solution: q['explanation'] ?? "No explanation.",
      );
    });

    // Navigate to Result Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultView(results: results)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (_viewModel.quizQuestions.isEmpty)
            return const Center(child: Text("No questions found."));

          final questionData = _viewModel.quizQuestions[currentQuestionIndex];
          final List<dynamic> options = questionData['options'] ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question
                Text(
                  "Q${currentQuestionIndex + 1}: ${questionData['question']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Options
                Expanded(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index].toString();
                      final isSelected =
                          _viewModel.userAnswers[currentQuestionIndex] ==
                          option;

                      return GestureDetector(
                        onTap: () => _viewModel.selectAnswer(
                          currentQuestionIndex,
                          option,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(option),
                        ),
                      );
                    },
                  ),
                ),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentQuestionIndex > 0)
                      ElevatedButton(
                        onPressed: () => setState(() => currentQuestionIndex--),
                        child: const Text("Previous"),
                      ),
                    ElevatedButton(
                      onPressed:
                          currentQuestionIndex ==
                              _viewModel.quizQuestions.length - 1
                          ? submitTest
                          : () => setState(() => currentQuestionIndex++),
                      child: Text(
                        currentQuestionIndex ==
                                _viewModel.quizQuestions.length - 1
                            ? "Submit"
                            : "Next",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
