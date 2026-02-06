import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const int itemCount = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(.08)),
        ],
      ),
      child: Stack(
        children: [
          /// 🔥 Animated underline (does NOT break layout)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            left:
                MediaQuery.of(context).size.width / itemCount * currentIndex +
                (MediaQuery.of(context).size.width / itemCount - 40) / 2,
            bottom: 6,
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          /// Bottom nav items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_outlined, "Home", 0),
              _navItem(Icons.menu_book_outlined, "Practice", 1),
              _navItem(Icons.emoji_events_outlined, "Leaderboard", 2),
              _navItem(Icons.groups_outlined, "Community", 3),
              _navItem(Icons.person_outline, "Profile", 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final active = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: active ? AppColors.softGreen : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: active ? AppColors.softGreen : Colors.grey,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
