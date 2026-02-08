import 'package:brainwave/view/auth/sign_up_view.dart';
import 'package:brainwave/view/main_shell.dart';
import 'package:brainwave/view/admin/admin_shell.dart'; // Import Admin Shell
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../viewmodel/auth_viewmodel.dart';
import 'forget_pass_view.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  // Instantiate ViewModel
  final AuthViewModel _viewModel = AuthViewModel();
  final AuthService _authService = AuthService(); // Instantiate AuthService

  // Controllers strictly for text input handling
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel, // Rebuilds when notifyListeners() is called
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
                mainAxisSize: MainAxisSize.min, // Wrap content tightly
                children: [
                  const Center(
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: "••••••••",
                    prefixIcon: Icons.lock_outline,
                    isPasswordField: true,
                    obscureText: !_viewModel.isPasswordVisible,
                    controller: _passwordController,
                    onChanged: (_) {},
                  ),

                  // Error Message Display
                  if (_viewModel.errorMessage != null &&
                      _viewModel.isWrongPassword)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  const SizedBox(height: 12),
                  _buildOptionsRow(context),
                  const SizedBox(height: 20),

                  _viewModel.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF7941D),
                          ),
                        )
                      : CustomButton(
                          title: "Log in",
                          backgroundColor: const Color(0xFFF7941D),
                          textColor: Colors.black,
                          icon: Icons.arrow_right_alt,
                          onTap: () async {
                            final success = await _viewModel.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            if (success && context.mounted) {
                              // ✅ Fetch Role and Navigate
                              final uid = _viewModel.user?.uid;
                              if (uid != null) {
                                final role = await _authService.getUserRole(
                                  uid,
                                );

                                if (!context.mounted) return;

                                if (role == 'admin') {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AdminShell(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainShell(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              }
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

  Widget _buildOptionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _viewModel.toggleRememberMe(!_viewModel.isRememberMe),
          child: Row(
            children: [
              Icon(
                _viewModel.isRememberMe
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: const Color(0xFFF7941D),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text("Remember me"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ForgetPassPage()),
          ),
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don’t have an account? "),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignUpView()),
          ),
          child: const Text(
            "Sign up",
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
