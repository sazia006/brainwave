import 'package:flutter/material.dart';

import '../../../viewmodel/otp_viewmodel.dart'; // Import your ViewModel

class OtpTimerBox extends StatefulWidget {
  final String title;
  final String email;
  final VoidCallback onVerify;

  // The View accepts the ViewModel to listen to it
  final OtpViewModel viewModel;

  // Callback to return the entered code to the parent
  final Function(String) onCodeChanged;

  const OtpTimerBox({
    super.key,
    required this.title,
    required this.email,
    required this.viewModel,
    required this.onVerify,
    required this.onCodeChanged,
  });

  @override
  State<OtpTimerBox> createState() => _OtpTimerBoxState();
}

class _OtpTimerBoxState extends State<OtpTimerBox> {
  // UI State: Controllers and FocusNodes belong in the View
  final int _otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  // UI Logic: Handle focus shifting
  void _onChanged(String value, int index) {
    // 1. Update the parent with the full code
    String currentCode = _controllers.map((c) => c.text).join();
    widget.onCodeChanged(currentCode);

    // 2. Handle Focus Jump
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use ListenableBuilder to rebuild only when ViewModel notifies (Timer tick)
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We have sent a code to your",
                style: TextStyle(color: Colors.grey[700]),
              ),
              Text(
                widget.email,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              /// OTP Boxes (UI Generation)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_otpLength, (index) {
                  return _buildOtpBox(index);
                }),
              ),

              const SizedBox(height: 12),

              /// Timer Display (From ViewModel)
              Text(
                "Code expires in: 00:${widget.viewModel.secondsRemaining.toString().padLeft(2, '0')}",
                style: const TextStyle(color: Colors.blue, fontSize: 14),
              ),
              const SizedBox(height: 24),

              /// Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onVerify,
                  icon: const Icon(Icons.arrow_right_alt),
                  label: const Text("Verify"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7941D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              // Optional: Resend Logic tied to VM state
              if (widget.viewModel.secondsRemaining == 0)
                TextButton(
                  onPressed: widget.viewModel.startTimer,
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(color: Color(0xFFF7941D)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 45,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        onChanged: (value) => _onChanged(value, index),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color(0xFFFFF3E8),
          contentPadding: const EdgeInsets.only(bottom: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFF7941D), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFF7941D), width: 2),
          ),
        ),
      ),
    );
  }
}
