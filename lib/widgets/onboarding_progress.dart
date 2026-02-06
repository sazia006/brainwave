import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import '../core/app_colors.dart';

class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<OnboardingViewModel>(context).currentPage;

    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: i <= page ? AppColors.accentYellow : Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }),
    );
  }
}
