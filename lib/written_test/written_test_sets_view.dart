import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_colors.dart';
import '../view/result/written_test_result_view.dart';
import 'submit_written_test_view.dart';
// ✅ Import the Result View we created earlier

class WrittenTestSetsView extends StatelessWidget {
  const WrittenTestSetsView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual User ID from your Auth Provider
    // String userId = FirebaseAuth.instance.currentUser!.uid;
    String userId = "CURRENT_USER_ID";

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
                    BackButton(color: Colors.white),
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
                  padding: EdgeInsets.only(left: 48),
                  child: Text(
                    "Select a practice set",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),

          /// ===== LIST CONTENT =====
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // 1. Stream Written Tests
              stream: FirebaseFirestore.instance
                  .collection('written_tests')
                  .snapshots(),
              builder: (context, testSnap) {
                if (testSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Stream User's Submissions (Nested Stream)
                // We check 'written_submissions' to see the status of each test for THIS user
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('written_submissions')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, subSnap) {
                    if (!subSnap.hasData) return const SizedBox();

                    final tests = testSnap.data!.docs;
                    final submissions = subSnap.data!.docs;

                    if (tests.isEmpty) {
                      return const Center(
                        child: Text("No written tests available."),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: tests.length,
                      itemBuilder: (context, index) {
                        // A. Get Test Data
                        final testDoc = tests[index];
                        final testData = testDoc.data() as Map<String, dynamic>;
                        final String testId = testDoc.id;

                        // B. Find Matching Submission (if any)
                        DocumentSnapshot? submissionDoc;
                        try {
                          submissionDoc = submissions.firstWhere(
                            (sub) => sub['testId'] == testId,
                          );
                        } catch (e) {
                          submissionDoc = null;
                        }

                        // C. Determine Status
                        String status = "start"; // Default
                        if (submissionDoc != null) {
                          status = submissionDoc['status'] ?? 'pending';
                        }

                        // D. Prepare Data for UI
                        final List<dynamic> rawQuestions =
                            testData['questions'] ?? [];
                        final String questionCount =
                            "${rawQuestions.length} Questions";

                        return _WrittenSetCard(
                          title: testData['title'] ?? "Untitled Test",
                          subject: testData['subject'] ?? "General",
                          questions: questionCount,
                          time: "${testData['duration'] ?? 60} mins",
                          status: status, // Pass status instead of boolean
                          onTap: () {
                            // --- NAVIGATION LOGIC ---
                            if (status == 'start') {
                              // 1. Start Test
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SubmitWrittenTestView(
                                    // Make sure SubmitView accepts testId now!
                                    // testId: testId,
                                    setTitle: testData['title'],
                                    subject: testData['subject'],
                                    questions: rawQuestions
                                        .map((e) => e.toString())
                                        .toList(),
                                  ),
                                ),
                              );
                            } else if (status == 'evaluated') {
                              // 2. View Result (PASS ACTUAL DATA)
                              final subData =
                                  submissionDoc!.data() as Map<String, dynamic>;

                              // Format Date safely
                              String dateStr = "Unknown Date";
                              if (subData['evaluatedAt'] != null) {
                                DateTime date =
                                    (subData['evaluatedAt'] as Timestamp)
                                        .toDate();
                                dateStr =
                                    "${date.year}-${date.month}-${date.day}";
                              }

                              // Parse Feedback List
                              List<Map<String, dynamic>> feedbacks = [];
                              if (subData['feedbackList'] != null) {
                                feedbacks = List<Map<String, dynamic>>.from(
                                  subData['feedbackList'],
                                );
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WrittenTestResultView(
                                    testTitle: testData['title'],
                                    totalScore: subData['totalScore'] ?? 100,
                                    obtainedScore: subData['score'] ?? 0,
                                    evaluatorName:
                                        subData['evaluatorName'] ??
                                        "Instructor",
                                    evaluationDate: dateStr,
                                    feedbackList: feedbacks,
                                  ),
                                ),
                              );
                            } else {
                              // 3. Pending
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Submission is under review."),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
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

// --- UPDATED CARD WIDGET ---
class _WrittenSetCard extends StatelessWidget {
  final String title;
  final String subject;
  final String questions;
  final String time;
  final String
  status; // Changed from bool to String ('start', 'pending', 'evaluated')
  final VoidCallback onTap;

  const _WrittenSetCard({
    required this.title,
    required this.subject,
    required this.questions,
    required this.time,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // visual logic based on status
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'evaluated':
        statusColor = Colors.green;
        statusText = "View Result";
        statusIcon = Icons.visibility;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = "Pending";
        statusIcon = Icons.hourglass_empty;
        break;
      default:
        statusColor = const Color(0xFF5B7CFF);
        statusText = "Start Test";
        statusIcon = Icons.play_arrow;
    }

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
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            questions,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.timer, size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Dynamic Status Button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      if (status != 'pending') ...[
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
