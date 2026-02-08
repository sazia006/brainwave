import 'package:brainwave/view/auth/success_view.dart';
import 'package:flutter/material.dart';

import '../../viewmodel/auth_viewmodel.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';

class ResetPassView extends StatefulWidget {
  const ResetPassView({super.key});

  @override
  State<ResetPassView> createState() => _ResetPassViewState();
}

class _ResetPassViewState extends State<ResetPassView> {
  final AuthViewModel _viewModel = AuthViewModel();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return AuthScaffold(
          showBackButton: false,
          footer: null,
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  const Center(
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "The password must be different than before",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // New Password
                  const Text(
                    "New Password",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: "••••••••",
                    prefixIcon: Icons.lock_outline,
                    isPasswordField: true,
                    obscureText: !_viewModel.isPasswordVisible,
                    controller: _newPasswordController,
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password
                  const Text(
                    "Confirm Password",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: "••••••••",
                    prefixIcon: Icons.lock_outline,
                    isPasswordField: true,
                    obscureText: !_viewModel.isPasswordVisible,
                    controller: _confirmPasswordController,
                    onChanged: (value) {},
                  ),

                  // Error Message
                  if (_viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Reset Button
                  _viewModel.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF7941D),
                          ),
                        )
                      : CustomButton(
                          title: "Continue",
                          backgroundColor: const Color(0xFFF7941D),
                          textColor: Colors.black,
                          icon: Icons.arrow_right_alt,
                          onTap: () async {
                            final success = await _viewModel.resetPassword(
                              _newPasswordController.text.trim(),
                              _confirmPasswordController.text.trim(),
                            );

                            if (success && context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SuccessView(
                                    message: "Password Reset Successful!",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
