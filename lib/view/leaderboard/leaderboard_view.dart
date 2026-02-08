import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../viewmodel/leaderboard_viewmodel.dart'; // Import ViewModel

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  final LeaderboardViewModel _viewModel = LeaderboardViewModel();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.softGreen),
            ),
          );
        }

        // Safe access to top 3 data
        final list = _viewModel.leaderboard;
        final first = list.isNotEmpty ? list[0] : null;
        final second = list.length > 1 ? list[1] : null;
        final third = list.length > 2 ? list[2] : null;

        // The rest of the list (Rank 4 onwards)
        final restList = list.length > 3 ? list.sublist(3) : [];

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
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 10),
                        const Text(
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
                      children: [
                        // Rank 2 (Left)
                        if (second != null)
                          _Podium(
                            rank: 2,
                            name: second['name'] ?? 'User',
                            points: "${second['points'] ?? 0} pts",
                            color: Colors.grey,
                          )
                        else
                          const SizedBox(width: 80), // Spacer if empty
                        // Rank 1 (Center - Big)
                        if (first != null)
                          _Podium(
                            rank: 1,
                            name: first['name'] ?? 'User',
                            points: "${first['points'] ?? 0} pts",
                            color: Colors.amber,
                            big: true,
                          )
                        else
                          const SizedBox(width: 100),

                        // Rank 3 (Right)
                        if (third != null)
                          _Podium(
                            rank: 3,
                            name: third['name'] ?? 'User',
                            points: "${third['points'] ?? 0} pts",
                            color: Colors.orange,
                          )
                        else
                          const SizedBox(width: 80),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ===== RANK LIST =====
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: restList.length,
                  itemBuilder: (context, index) {
                    final user = restList[index];
                    // Rank is index + 4 (because 1,2,3 are on podium)
                    return _RankRow(
                      index + 4,
                      user['name'] ?? "Unknown",
                      "45 tests • 90% accuracy", // Placeholder stats
                      user['points'] ?? 0,
                    );
                  },
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          "Your Rank\n#${_viewModel.userRank > 0 ? _viewModel.userRank : '-'}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const Text(
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
      },
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
                name.isNotEmpty
                    ? name
                          .split(" ")
                          .map((e) => e[0])
                          .take(2)
                          .join()
                          .toUpperCase()
                    : "U",
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
