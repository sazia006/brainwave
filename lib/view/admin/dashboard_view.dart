import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/stat_card.dart';

class DashboardView extends StatelessWidget {
  final Function(int)? onQuickAction;

  const DashboardView({super.key, this.onQuickAction});

  // Helper to fetch real-time count
  Stream<int> _countStream(String collection) {
    return FirebaseFirestore.instance
        .collection(collection)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Overview",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // --- 1. STAT CARDS (Real-time) ---
          StreamBuilder(
            stream: _countStream('questions'),
            builder: (context, AsyncSnapshot<int> qSnap) {
              return StreamBuilder(
                stream: _countStream('evaluations'),
                builder: (context, AsyncSnapshot<int> eSnap) {
                  return StreamBuilder(
                    stream: _countStream('users'),
                    builder: (context, AsyncSnapshot<int> uSnap) {
                      final totalQuestions = qSnap.data ?? 0;
                      final pending = eSnap.data ?? 0;
                      final users = uSnap.data ?? 0;

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          bool isMobile = constraints.maxWidth < 800;

                          if (isMobile) {
                            return Column(
                              children: [
                                StatCard(
                                  title: "Total Questions",
                                  value: "$totalQuestions",
                                  icon: Icons.quiz,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 16),
                                StatCard(
                                  title: "Pending Evaluations",
                                  value: "$pending",
                                  icon: Icons.assignment_late,
                                  color: Colors.orange,
                                ),
                                const SizedBox(height: 16),
                                StatCard(
                                  title: "Total Users",
                                  value: "$users",
                                  icon: Icons.people,
                                  color: Colors.green,
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  title: "Total Questions",
                                  value: "$totalQuestions",
                                  icon: Icons.quiz,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatCard(
                                  title: "Pending Evaluations",
                                  value: "$pending",
                                  icon: Icons.assignment_late,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatCard(
                                  title: "Total Users",
                                  value: "$users",
                                  icon: Icons.people,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),

          const SizedBox(height: 40),

          // --- 2. QUICK ACTIONS ---
          const Text(
            "Quick Actions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;

              // ✅ FIX: Define the cards first
              final card1 = _QuickActionCard(
                title: "Upload Questions",
                icon: Icons.upload_file,
                color: Colors.blue,
                onTap: () => onQuickAction?.call(1),
              );

              final card2 = _QuickActionCard(
                title: "Evaluate Sheets",
                icon: Icons.assignment_turned_in,
                color: Colors.green,
                onTap: () => onQuickAction?.call(2),
              );

              final card3 = _QuickActionCard(
                title: "Manage DB",
                icon: Icons.storage,
                color: Colors.orange,
                onTap: () => onQuickAction?.call(3),
              );

              final card4 = _QuickActionCard(
                title: "Written Tests",
                icon: Icons.description,
                color: Colors.purple,
                onTap: () => onQuickAction?.call(4),
              );

              // ✅ FIX: Simple Logic (No complex mapping)
              if (isMobile) {
                return Column(
                  children: [
                    card1,
                    const SizedBox(height: 16),
                    card2,
                    const SizedBox(height: 16),
                    card3,
                    const SizedBox(height: 16),
                    card4,
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(child: card1),
                    const SizedBox(width: 20),
                    Expanded(child: card2),
                    const SizedBox(width: 20),
                    Expanded(child: card3),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// Internal Widget for Quick Actions
class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
