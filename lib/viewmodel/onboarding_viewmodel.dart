import 'package:flutter/material.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController controller = PageController();
  int currentPage = 0;

  void updatePage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
