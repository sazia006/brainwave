import 'package:brainwave/view/auth/sign_in_view.dart';
import 'package:flutter/material.dart';
import '../../viewmodel/auth_viewmodel.dart';
import 'reset_verify_view.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({super.key});

  @override
  State<ForgetPassPage> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPassPage> {
  final AuthViewModel _viewModel = AuthViewModel();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return AuthScaffold(
          showBackButton: true,
          footer: _buildFooter(context),
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
                  const Center(
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Enter your email account to reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(height: 22),

                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: "Enter your email",
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    onChanged: (value) {},
                  ),

                  if (_viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  const SizedBox(height: 16),

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
                            final email = _emailController.text.trim();

                            // 1. Check if method name is sendForgotPassOtp OR sendPasswordResetEmail
                            // We are using the OTP flow, so usually sendForgotPassOtp
                            final success = await _viewModel.sendForgotPassOtp(
                              email,
                            );

                            if (success && context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // 2. FIXED: Must pass the 'email' here!
                                  builder: (_) =>
                                      ResetVerifyScreen(email: email),
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

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Remember your password? "),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignInView()),
            );
          },
          child: const Text(
            "Log in",
            style: TextStyle(
              color: Color(0xFFF7941D),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
