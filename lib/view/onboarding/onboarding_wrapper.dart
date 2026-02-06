import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/onboarding_viewmodel.dart';
import 'onboarding1_view.dart';
import 'onboarding2_view.dart';
import 'onboarding3_view.dart';

class OnboardingWrapper extends StatelessWidget {
  const OnboardingWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: Consumer<OnboardingViewModel>(
        builder: (_, vm, __) {
          return PageView(
            controller: vm.controller,
            onPageChanged: vm.updatePage,
            children: const [
              Onboarding1View(),
              Onboarding2View(),
              Onboarding3View(),
            ],
          );
        },
      ),
    );
  }
}
