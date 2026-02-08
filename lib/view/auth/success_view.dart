import 'package:brainwave/view/auth/sign_in_view.dart';
import 'package:flutter/material.dart';

import '../../core/image_path.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/custom_button.dart';

class SuccessView extends StatelessWidget {
  final String message;
  final String? subMessage;

  const SuccessView({super.key, this.message = "Success!", this.subMessage});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: false,
      child: Center(
        child: Column(
          children: [
            Image.asset(ImagePath.success2, height: 150),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (subMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                subMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
            const SizedBox(height: 24),
            CustomButton(
              title: "Continue",
              backgroundColor: const Color(0xFFF7941D),
              textColor: Colors.black,
              icon: Icons.arrow_right_alt,
              onTap: () {
                // Navigate to Dashboard or Login depending on flow
                // For now, going back to Login as a safe default for Auth flow
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInView()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
