import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import '../core/app_colors.dart';
import 'onboarding_progress.dart';

class OnboardingLayout extends StatelessWidget {
  final List<Color> gradient;
  final IconData icon;
  final String tag;
  final String title;
  final String desc;
  final bool last;

  const OnboardingLayout({
    super.key,
    required this.gradient,
    required this.icon,
    required this.tag,
    required this.title,
    required this.desc,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<OnboardingViewModel>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _LangChip(),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/admin"),
                child: const Text("Skip"),
              ),
            ],
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Icon(icon, size: 60, color: gradient.last),
          ),

          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: gradient.last,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(tag, style: const TextStyle(color: Colors.white)),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreen,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            desc,
            style: const TextStyle(color: AppColors.darkGreen),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          const OnboardingProgress(),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: last
                  ? () => Navigator.pushReplacementNamed(context, "/login")
                  : vm.nextPage,
              child: Text(last ? "Get Started" : "Next"),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: const [
          Icon(Icons.language, size: 16),
          SizedBox(width: 6),
          Text("বাংলা"),
        ],
      ),
    );
  }
}
