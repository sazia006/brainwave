import 'package:flutter/material.dart';
import '../../viewmodel/otp_viewmodel.dart';
import 'reset_pass_view.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/otp_timer_box.dart';

class ResetVerifyScreen extends StatefulWidget {
  final String email;

  const ResetVerifyScreen({
    super.key,
    required this.email,
  }); // Email is required

  @override
  State<ResetVerifyScreen> createState() => _ResetVerifyScreenState();
}

class _ResetVerifyScreenState extends State<ResetVerifyScreen> {
  final OtpViewModel _viewModel = OtpViewModel();
  String _currentCode = "";

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Stack(
        children: [
          OtpTimerBox(
            title: "Enter Verification Code",
            email: widget.email,
            viewModel: _viewModel,
            onCodeChanged: (code) {
              _currentCode = code;
            },
            onVerify: () async {
              // PASS THE EMAIL HERE 👇
              final success = await _viewModel.verifyOtp(
                _currentCode,
                email: widget.email,
              );

              if (!mounted) return;

              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ResetPassView()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid Code"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),

          if (_viewModel.isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFF7941D)),
              ),
            ),
        ],
      ),
    );
  }
}
