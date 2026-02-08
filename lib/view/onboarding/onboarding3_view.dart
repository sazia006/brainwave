import 'package:flutter/material.dart';

import '../../widgets/onboarding_layout.dart';

class Onboarding3View extends StatelessWidget {
  const Onboarding3View({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      gradient: const [Color(0xFFD1FAE5), Color.fromARGB(255, 164, 249, 218)],
      icon: Icons.group_rounded,
      tag: "Join a community of learners",
      title: "Learn Together, Grow Together",
      desc: "Connect, compete, and grow with fellow learners.",
      last: true,
    );
  }
}
