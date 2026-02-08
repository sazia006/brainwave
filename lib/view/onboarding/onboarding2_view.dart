import 'package:flutter/material.dart';

import '../../widgets/onboarding_layout.dart';

class Onboarding2View extends StatelessWidget {
  const Onboarding2View({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      gradient: const [Color(0xFFFFEDD5), Color.fromARGB(255, 222, 147, 94)],
      icon: Icons.menu_book_rounded,
      tag: "Prepare like never before",
      title: "Practice & Real Exam Simulation",
      desc: "Practice past year questions with real exam experience.",
    );
  }
}
