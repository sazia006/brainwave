import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure you have google_fonts in pubspec.yaml
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Scaffold handles the basic layout structure better than just a Container
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // This prevents the overflow when content is too tall
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                // This keeps the Spacer-like behavior within a ScrollView
                constraints: BoxConstraints(minHeight: size.height - 100),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _LangChip(),
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              "/login",
                            ),
                            child: Text(
                              "Skip",
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 1),
                      // Icon Container
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape
                              .circle, // Circular looks cleaner for onboarding
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(icon, size: 60, color: gradient.last),
                      ),
                      const SizedBox(height: 40),
                      // Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Title
                      Text(
                        title,
                        style: GoogleFonts.hindSiliguri(
                          // Great for Bengali/English mix
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Text(
                        desc,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: AppColors.darkGreen.withOpacity(0.8),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 2),
                      const OnboardingProgress(),
                      const SizedBox(height: 32),
                      // Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: last
                              ? () => Navigator.pushReplacementNamed(
                                  context,
                                  "/login",
                                )
                              : vm.nextPage,
                          child: Text(
                            last ? "Get Started" : "Continue",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, size: 18, color: AppColors.darkGreen),
          const SizedBox(width: 8),
          Text(
            "বাংলা",
            style: GoogleFonts.hindSiliguri(
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}
