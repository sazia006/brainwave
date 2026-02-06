import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.person, size: 80, color: AppColors.softGreen),
          SizedBox(height: 16),
          Text(
            "My Profile",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("Account & progress overview"),
        ],
      ),
    );
  }
}
