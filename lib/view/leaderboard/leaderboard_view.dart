import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          /// ===== TOP HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B7CFF), Color(0xFF7B4CFF)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Leaderboard",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _TopRank("Rahim Khan", "9720 pts", "RK", Colors.grey, "2"),
                    _TopRank(
                      "Fatima Rahman",
                      "9850 pts",
                      "FR",
                      Colors.amber,
                      "1",
                    ),
                    _TopRank(
                      "Ayesha Sultana",
                      "9580 pts",
                      "AS",
                      Colors.orange,
                      "3",
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ===== RANKING LIST =====
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _RankItem(4, "Karim Ahmed", "45 tests • 90% accuracy", 9340),
                _RankItem(5, "Nazia Islam", "47 tests • 89% accuracy", 9210),
                _RankItem(6, "Imran Hossain", "44 tests • 88% accuracy", 9080),
                _RankItem(7, "Sadia Begum", "46 tests • 87% accuracy", 8950),
              ],
            ),
          ),

          /// ===== YOUR RANK =====
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A7CFF), Color(0xFF7C52FF)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Your Rank\n#8 of 2,547",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  "+3 ranks\nThis Week",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= WIDGETS =================

class _TopRank extends StatelessWidget {
  final String name;
  final String points;
  final String initials;
  final Color medalColor;
  final String rank;

  const _TopRank(
    this.name,
    this.points,
    this.initials,
    this.medalColor,
    this.rank,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: medalColor.withOpacity(.2),
              child: Text(
                initials,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: medalColor,
              child: Text(
                rank,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Text(
          points,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

class _RankItem extends StatelessWidget {
  final int rank;
  final String name;
  final String stats;
  final int points;

  const _RankItem(this.rank, this.name, this.stats, this.points);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Text("#$rank"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(stats, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(
            "$points\npoints",
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
