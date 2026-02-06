import 'package:flutter/material.dart';

import '../../widgets/onboarding_layout.dart';

class Onboarding1View extends StatelessWidget {
  const Onboarding1View({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      gradient: const [Color(0xFFEDE9FE), Color(0xFF8B5CF6)],
      icon: Icons.psychology_alt,
      tag: "স্মার্ট এআই সুপারিশ",
      title: "ব্যক্তিগত শিক্ষা ব্যবস্থা",
      desc: "আমাদের এআই আপনার দক্ষতা বিশ্লেষণ করে শেখার পথ তৈরি করে।",
    );
  }
}
