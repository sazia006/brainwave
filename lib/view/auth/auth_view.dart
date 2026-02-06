import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../../widgets/auth_textfield.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const _AuthBody(),
    );
  }
}

class _AuthBody extends StatelessWidget {
  const _AuthBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D5DF6), Color(0xFF8A4AF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "BrainWave",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _Tab("Login", vm.isLogin, vm.toggle),
                          _Tab("Register", !vm.isLogin, vm.toggle),
                        ],
                      ),
                      const SizedBox(height: 30),
                      AuthTextField(hint: "Email", icon: Icons.email_outlined),
                      const SizedBox(height: 16),
                      AuthTextField(
                        hint: "Password",
                        icon: Icons.lock_outline,
                        obscure: true,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(vm.isLogin ? "Login" : "Register"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _Tab(this.text, this.active, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.grey.shade200,
          ),
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}
