import 'package:flutter/material.dart';

import '../../widgets/onboarding_layout.dart';

class Onboarding1View extends StatelessWidget {
  const Onboarding1View({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      gradient: const [Color(0xFFEDE9FE), Color.fromARGB(255, 183, 159, 239)],
      icon: Icons.psychology_alt,
      tag: "Smart AI Suggestions",
      title: "Personalized Learning System",
      desc:
          "Our AI analyzes your performance and creates a personalized learning path to help you master every topic efficiently.",
    );
  }
}
