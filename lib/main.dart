// import 'package:brainwave/view/auth/auth_view.dart';
import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'view/splash/splash_view.dart';
import 'view/onboarding/onboarding_wrapper.dart';
import 'view/main_shell.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      routes: {
        "/": (_) => const SplashView(),
        "/onboarding": (_) => const OnboardingWrapper(),
        // "/auth": (_) => const AuthView(),
        "/main": (_) => const MainShell(),
      },
    );
  }
}
