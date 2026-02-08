import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_colors.dart';
import 'submit_written_test_view.dart'; // Ensure this import is correct

class WrittenTestSetsView extends StatelessWidget {
  const WrittenTestSetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          /// ===== HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B7CFF), Color(0xFF7B4CFF)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BackButton(color: Colors.white), // Added back button
                    SizedBox(width: 8),
                    Text(
                      "Written Test",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 48), // Align with title
                  child: Text(
                    "Select a practice set",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),

          /// ===== FIRESTORE LIST =====
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('written_tests')
                  .snapshots(),
              builder: (context, snapshot) {
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Error State
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading tests"));
                }

                // 3. Empty State
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No written tests available."),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    // Extract Data safely
                    final String title = data['title'] ?? "Untitled Test";
                    final String subject = data['subject'] ?? "General";
                    final int duration = data['duration'] ?? 60;

                    // Crucial: Get the questions array
                    final List<dynamic> rawQuestions = data['questions'] ?? [];
                    final List<String> questionsList = rawQuestions
                        .map((e) => e.toString())
                        .toList();

                    return _WrittenSetCard(
                      title: title,
                      subject: subject,
                      questions: "${questionsList.length} Questions",
                      time: "$duration mins",
                      completed:
                          false, // You can link this to a 'submissions' check later
                      onTap: () {
                        // Navigate and Pass Data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubmitWrittenTestView(
                              setTitle: title,
                              subject: subject,
                              questions:
                                  questionsList, // ✅ Passing fetched questions
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET: CARD ---
class _WrittenSetCard extends StatelessWidget {
  final String title;
  final String subject;
  final String questions;
  final String time;
  final bool completed;
  final VoidCallback onTap;

  const _WrittenSetCard({
    required this.title,
    required this.subject,
    required this.questions,
    required this.time,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.description, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(questions, style: const TextStyle(color: Colors.black54)),
                const SizedBox(width: 14),
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(time, style: const TextStyle(color: Colors.black54)),
              ],
            ),
            if (completed)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Completed",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
