import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class PracticeView extends StatelessWidget {
  const PracticeView({super.key});

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
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Practice",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Improve your skills",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ===== PRACTICE OPTIONS =====
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _PracticeCard(
                  icon: Icons.menu_book,
                  color: Colors.green,
                  title: "Easy",
                  sets: "15 Sets",
                  desc: "Basic concepts and simple questions",
                  onTap: () => Navigator.pushNamed(context, "/easy"),
                ),

                _PracticeCard(
                  icon: Icons.psychology,
                  color: Colors.orange,
                  title: "Medium",
                  sets: "12 Sets",
                  desc: "Moderate level challenging questions",
                  onTap: () => Navigator.pushNamed(context, "/medium"),
                ),

                _PracticeCard(
                  icon: Icons.emoji_events,
                  color: Colors.red,
                  title: "Hard",
                  sets: "8 Sets",
                  desc: "Advanced level complex problems",
                  onTap: () => Navigator.pushNamed(context, "/hard"),
                ),

                _PracticeCard(
                  icon: Icons.description,
                  color: Colors.purple,
                  title: "Written Test",
                  sets: "New",
                  desc: "Upload answer images and get evaluated",
                  highlight: true,
                  onTap: () => Navigator.pushNamed(context, "/written"),
                ),

                const SizedBox(height: 20),

                const _ProgressCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= PRACTICE CARD =================

class _PracticeCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String sets;
  final String desc;
  final bool highlight;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.sets,
    required this.desc,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFF2ECFF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(.05)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(.15),
              child: Icon(icon, color: color),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: highlight ? Colors.purple : color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          sets,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(desc, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

/// ================= PROGRESS CARD =================

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF3FF), Color(0xFFF8F6FF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ProgressItem("127", "Completed", Colors.blue),
          _ProgressItem("85%", "Accuracy", Colors.green),
          _ProgressItem("42", "Streak", Colors.purple),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _ProgressItem(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
