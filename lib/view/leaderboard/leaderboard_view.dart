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
          /// ===== PODIUM HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
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

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    _Podium(
                      rank: 2,
                      name: "Rahim Khan",
                      points: "9720 pts",
                      color: Colors.grey,
                    ),
                    _Podium(
                      rank: 1,
                      name: "Fatima Rahman",
                      points: "9850 pts",
                      color: Colors.amber,
                      big: true,
                    ),
                    _Podium(
                      rank: 3,
                      name: "Ayesha Sultana",
                      points: "9580 pts",
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ===== RANK LIST =====
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _RankRow(4, "Karim Ahmed", "45 tests • 90% accuracy", 9340),
                _RankRow(5, "Nazia Islam", "47 tests • 89% accuracy", 9210),
                _RankRow(6, "Imran Hossain", "44 tests • 88% accuracy", 9080),
                _RankRow(7, "Sadia Begum", "46 tests • 87% accuracy", 8950),
              ],
            ),
          ),

          /// ===== YOUR RANK CARD =====
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A7CFF), Color(0xFF7C52FF)],
              ),
              borderRadius: BorderRadius.circular(22),
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
                  "+3 ranks\nThis week",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= PODIUM =================

class _Podium extends StatelessWidget {
  final int rank;
  final String name;
  final String points;
  final Color color;
  final bool big;

  const _Podium({
    required this.rank,
    required this.name,
    required this.points,
    required this.color,
    this.big = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: big ? 40 : 32,
              backgroundColor: color.withOpacity(.25),
              child: Text(
                name.split(" ").map((e) => e[0]).take(2).join(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            CircleAvatar(
              radius: 13,
              backgroundColor: color,
              child: Text(
                "$rank",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Text(
          points,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

/// ================= RANK ROW =================

class _RankRow extends StatelessWidget {
  final int rank;
  final String name;
  final String stats;
  final int points;

  const _RankRow(this.rank, this.name, this.stats, this.points);

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
