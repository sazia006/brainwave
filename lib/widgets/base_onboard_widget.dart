import 'package:flutter/material.dart';

class BaseOnboard extends StatelessWidget {
  final List<Color> colors;
  final IconData icon;
  final String title;
  final String subtitle;
  final String desc;
  final VoidCallback onNext;

  const BaseOnboard({
    super.key,
    required this.colors,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          Icon(icon, size: 80, color: colors.last),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(desc, textAlign: TextAlign.center),
          const Spacer(),
          ElevatedButton(onPressed: onNext, child: const Text("Next")),
        ],
      ),
    );
  }
}
