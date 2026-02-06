import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  int currentQuestion = 0;

  final questions = [
    {
      "question": "What is the capital of Bangladesh?",
      "options": ["Dhaka", "Chittagong", "Sylhet", "Rajshahi"],
      "answer": 0,
    },
    {
      "question": "Which gas is essential for breathing?",
      "options": ["Nitrogen", "Oxygen", "Hydrogen", "Carbon"],
      "answer": 1,
    },
    {
      "question": "2 + 2 equals?",
      "options": ["3", "4", "5", "6"],
      "answer": 1,
    },
  ];

  int? selectedOption;

  void next() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedOption = null;
      });
    }
  }

  void previous() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
        selectedOption = null;
      });
    }
  }

  void submitTest() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Test Submitted"),
        content: const Text("Your answers have been submitted successfully!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];
    final progress = (currentQuestion + 1) / questions.length;

    return Scaffold(
      backgroundColor: AppColors.cream,

      /// 🚫 No chatbot here (just don’t include FAB)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// ===== TOP BAR =====
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      "Physics - Basic Mechanics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.bookmark_border),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                "Question ${currentQuestion + 1} of ${questions.length}",
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.softGreen,
                      child: Text(
                        "${currentQuestion + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        q["question"] as String,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ===== OPTIONS =====
              ...(q["options"] as List<String>).asMap().entries.map((e) {
                final index = e.key;
                final option = e.value;

                final selected = selectedOption == index;

                return GestureDetector(
                  onTap: () => setState(() => selectedOption = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.softGreen.withOpacity(.15)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? AppColors.softGreen
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: selected
                              ? AppColors.softGreen
                              : Colors.transparent,
                          child: selected
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          String.fromCharCode(65 + index),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(option)),
                      ],
                    ),
                  ),
                );
              }),

              const Spacer(),

              /// ===== NAV BUTTONS =====
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: previous,
                      child: const Text("Previous"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: currentQuestion == questions.length - 1
                          ? submitTest
                          : next,
                      child: Text(
                        currentQuestion == questions.length - 1
                            ? "Submit"
                            : "Next",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border),
                label: const Text("Save Question"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
