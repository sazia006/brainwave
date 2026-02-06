import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.groups, size: 80, color: AppColors.softGreen),
          SizedBox(height: 16),
          Text(
            "Community Hub",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("Study groups & discussions"),
        ],
      ),
    );
  }
}
