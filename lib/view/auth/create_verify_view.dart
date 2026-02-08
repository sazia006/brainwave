import 'package:brainwave/view/auth/success_view.dart';
import 'package:flutter/material.dart';
import '../../viewmodel/otp_viewmodel.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/otp_timer_box.dart';

class CreateVerifyScreen extends StatefulWidget {
  final String email;

  const CreateVerifyScreen({super.key, required this.email});

  @override
  State<CreateVerifyScreen> createState() => _CreateVerifyScreenState();
}

class _CreateVerifyScreenState extends State<CreateVerifyScreen> {
  // ViewModel instance for logic
  final OtpViewModel _viewModel = OtpViewModel();

  // Local state to hold the code entered by the user
  String _currentCode = "";

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: OtpTimerBox(
        title: "Verify Account",
        email: widget.email,
        viewModel: _viewModel, // Pass VM so box listens to timer
        onCodeChanged: (code) {
          // Update local state whenever user types
          _currentCode = code;
        },
        onVerify: () async {
          // Trigger business logic
          // Note: ensure your OtpViewModel has a method like validateCode or verifyCode
          final success = await _viewModel.verifyOtp(_currentCode);

          if (!mounted) return;

          if (success) {
            // Success Logic
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const SuccessView(message: "Account Created Successfully!"),
              ),
            );
          } else {
            // Error Logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Invalid verification code"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}
