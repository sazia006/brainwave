import 'package:brainwave/view/auth/sign_in_view.dart';
import 'package:flutter/material.dart';
import '../../viewmodel/auth_viewmodel.dart';
import 'create_verify_view.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // ViewModel instance
  final AuthViewModel _viewModel = AuthViewModel();

  // UI State: Controllers live in the View
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Footer widget pinned to bottom center
    final Widget footer = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
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

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return AuthScaffold(
          showBackButton: false,
          footer: footer,
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
                children: [
                  // Title
                  const Center(
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Name Input
                  const Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: "Enter your name",
                    prefixIcon: Icons.person_outline,
                    controller: _nameController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),

                  // Email Input
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
                  const SizedBox(height: 16),

                  // Password Input
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
                    // Note: If you want a toggle icon, you'd add a suffix icon here
                    // mapped to _viewModel.togglePasswordVisibility()
                    controller: _passwordController,
                    onChanged: (value) {},
                  ),

                  // Error Message
                  if (_viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        _viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Signup Button
                  _viewModel.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF7941D),
                          ),
                        )
                      : CustomButton(
                          title: "Create",
                          backgroundColor: const Color(0xFFF7941D),
                          textColor: Colors.black,
                          icon: Icons.arrow_right_alt,
                          onTap: () async {
                            final email = _emailController.text.trim();

                            // Call ViewModel Logic
                            final success = await _viewModel.signUp(
                              _nameController.text.trim(),
                              email,
                              _passwordController.text.trim(),
                            );

                            if (success && context.mounted) {
                              // Navigate to Verify Page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CreateVerifyView(email: email),
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
