import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../viewmodel/test_viewmodel.dart';
import '../result/result_view.dart';

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

  // Timer State
  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.loadTest(widget.setId).then((_) {
      // Start timer with duration from Admin (or default 30 mins)
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
        submitTest(); // Auto-submit when time is up
      }
    });
  }

  String get timerText {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void next() {
    if (currentQuestionIndex < _viewModel.quizQuestions.length - 1) {
      setState(() => currentQuestionIndex++);
    }
  }

  void previous() {
    if (currentQuestionIndex > 0) {
      setState(() => currentQuestionIndex--);
    }
  }

  // ✅ UPDATED SUBMIT LOGIC
  void submitTest() {
    _timer?.cancel();

    // 1. Convert ViewModel data into List<QuestionResult>
    final List<QuestionResult> results = List.generate(
      _viewModel.quizQuestions.length,
      (index) {
        final q = _viewModel.quizQuestions[index];
        return QuestionResult(
          question: q['question'] ?? "No Question Text",
          correctAnswer: q['correctAnswer'] ?? "",
          userAnswer: _viewModel.userAnswers[index], // Pass null if skipped
          solution: q['explanation'] ?? "No explanation provided.",
        );
      },
    );

    // 2. Navigate to your ResultView
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultView(results: results)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            if (_viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.softGreen),
              );
            }

            if (_viewModel.quizQuestions.isEmpty) {
              return const Center(
                child: Text("No questions available in this set."),
              );
            }

            final questionData = _viewModel.quizQuestions[currentQuestionIndex];
            final List<dynamic> options = questionData['options'] ?? [];
            final progress =
                (currentQuestionIndex + 1) / _viewModel.quizQuestions.length;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// ===== TOP BAR =====
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _secondsRemaining < 60
                              ? Colors.red.withOpacity(0.1)
                              : AppColors.softGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 16,
                              color: _secondsRemaining < 60
                                  ? Colors.red
                                  : AppColors.softGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timerText,
                              style: TextStyle(
                                color: _secondsRemaining < 60
                                    ? Colors.red
                                    : AppColors.softGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(
                    "Question ${currentQuestionIndex + 1} of ${_viewModel.quizQuestions.length}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    color: AppColors.softGreen,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 24),

                  /// ===== QUESTION =====
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      questionData["question"] ?? "No Question Text",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ===== OPTIONS =====
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final String optionText = options[index].toString();
                        final bool isSelected =
                            _viewModel.userAnswers[currentQuestionIndex] ==
                            optionText;

                        return GestureDetector(
                          onTap: () => _viewModel.selectAnswer(
                            currentQuestionIndex,
                            optionText,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.softGreen.withOpacity(.15)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.softGreen
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: isSelected
                                      ? AppColors.softGreen
                                      : Colors.transparent,
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : Text(
                                          String.fromCharCode(65 + index),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? AppColors.softGreen
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// ===== NAV BUTTONS =====
                  Row(
                    children: [
                      if (currentQuestionIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: previous,
                            child: const Text("Previous"),
                          ),
                        ),
                      if (currentQuestionIndex > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.softGreen,
                            foregroundColor: Colors.white,
                          ),
                          onPressed:
                              currentQuestionIndex ==
                                  _viewModel.quizQuestions.length - 1
                              ? submitTest
                              : next,
                          child: Text(
                            currentQuestionIndex ==
                                    _viewModel.quizQuestions.length - 1
                                ? "Submit"
                                : "Next",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
