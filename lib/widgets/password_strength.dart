import 'package:flutter/material.dart';

class PasswordStrength extends StatelessWidget {
  final String password;

  const PasswordStrength({super.key, required this.password});

  int get strength {
    if (password.length < 6) return 1;
    if (password.length < 10) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: i < strength ? Colors.green : Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      }),
    );
  }
}
