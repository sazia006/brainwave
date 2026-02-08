import 'package:brainwave/view/auth/forget_pass_view.dart';
import 'package:brainwave/view/auth/sign_in_view.dart';
import 'package:brainwave/view/practice/easy_sets_view.dart';
import 'package:brainwave/view/practice/hard_sets_view.dart';
import 'package:brainwave/view/practice/medium_sets_view.dart';
import 'package:brainwave/view/practice/practice_view.dart';
import 'package:brainwave/written_test/written_test_sets_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/app_colors.dart';

import 'view/admin/admin_shell.dart';
import 'view/auth/reset_pass_view.dart';
import 'view/auth/sign_up_view.dart';
import 'view/auth/success_view.dart';
import 'view/splash/splash_view.dart';
import 'view/onboarding/onboarding_wrapper.dart';
import 'view/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const BrainWaveApp());
}

class BrainWaveApp extends StatelessWidget {
  const BrainWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.cream,
        primaryColor: AppColors.softGreen,
      ),
      // Defined initial route (optional if you have logic in Splash)
      initialRoute: "/",
      routes: {
        "/": (_) => const SplashView(),
        "/onboarding": (_) => const OnboardingWrapper(),
        "/admin": (_) => const AdminShell(),
        "/signup": (_) => const SignUpView(),
        // ❌ REMOVED: "/create_verify" (It is handled dynamically in code)
        "/login": (_) => const SignInView(),
        "/forgot": (_) => const ForgetPassPage(),
        // ❌ REMOVED: "/reset_verify" (It is handled dynamically in code)
        "/reset_pass": (_) => const ResetPassView(),
        "/success": (_) => const SuccessView(),
        "/main": (_) => const MainShell(),
        "/practice": (_) => const PracticeView(),
        "/easy": (_) => const EasySetsView(),
        "/medium": (_) => const MediumSetsView(),
        "/hard": (_) => const HardSetsView(),
        "/written": (_) => const WrittenTestSetsView(),
      },
    );
  }
}
