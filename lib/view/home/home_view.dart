import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../viewmodel/home_viewmodel.dart'; // Import the ViewModel

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Instantiate ViewModel
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        // Show loading spinner while fetching data
        if (_viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.softGreen),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER (Connected to Backend)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _viewModel.userName, // ✅ Real Name from Firestore
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.notifications_none),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            _viewModel.userName.isNotEmpty
                                ? _viewModel.userName[0].toUpperCase()
                                : "U", // ✅ First letter of name
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// PROGRESS CARD
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B5CF5), Color(0xFF9C7CFA)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Progress",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          _ProgressStat(
                            "Questions",
                            "0",
                          ), // Placeholder for now
                          _ProgressStat("Accuracy", "0%"),
                          _ProgressStat("Study Streak", "0 days"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const LinearProgressIndicator(
                        value: 0.1, // Placeholder
                        backgroundColor: Colors.white24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// PRACTICE GRID
                const Text(
                  "Practice Now",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: const [
                    _PracticeTile(Icons.quiz, "Practice MCQs", Colors.blue),
                    _PracticeTile(Icons.timer, "Mock Test", Colors.purple),
                    _PracticeTile(
                      Icons.show_chart,
                      "Performance",
                      Colors.green,
                    ),
                    _PracticeTile(
                      Icons.offline_bolt,
                      "Offline Mode",
                      Colors.orange,
                    ),
                    _PracticeTile(Icons.groups, "Community", Colors.pink),
                    _PracticeTile(
                      Icons.emoji_events,
                      "Leaderboard",
                      Colors.amber,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// RECENT ACTIVITY
                const Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Static for now, can be connected later
                const _ActivityItem("Physics Mock Test #12", "Score: 78%"),
                const _ActivityItem(
                  "Chemistry Practice",
                  "30 questions solved",
                ),

                const SizedBox(height: 24),

                /// DAILY SCHEDULE
                const Text(
                  "Daily Schedule",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const _ScheduleItem(
                  "Organic Chemistry Practice",
                  "High Priority",
                ),
                const _ScheduleItem("Math – Calculus Revision", "Medium"),
                const _ScheduleItem("Physics Mock Test", "High Priority"),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ---------- COMPONENTS ----------

class _ProgressStat extends StatelessWidget {
  final String title;
  final String value;

  const _ProgressStat(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class _PracticeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _PracticeTile(this.icon, this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(.05)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ActivityItem(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_circle_fill, color: AppColors.softGreen),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String title;
  final String priority;

  const _ScheduleItem(this.title, this.priority);

  @override
  Widget build(BuildContext context) {
    final isHigh = priority.contains("High");

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isHigh
                  ? Colors.red.withOpacity(.15)
                  : Colors.orange.withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              priority,
              style: TextStyle(color: isHigh ? Colors.red : Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
