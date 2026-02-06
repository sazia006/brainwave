import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/chatbot_fab.dart';

import 'home/home_view.dart';
import 'practice/practice_view.dart';
import 'leaderboard/leaderboard_view.dart';
import 'community/community_view.dart';
import 'profile/profile_view.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final pages = const [
    HomeView(),
    PracticeView(),
    LeaderboardView(),
    CommunityView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      floatingActionButton: const ChatBotFAB(),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
      ),
    );
  }
}
