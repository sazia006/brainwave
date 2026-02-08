import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChanged;

  const Sidebar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "BrainWave Admin",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // Menu Items
          _item(Icons.dashboard, "Dashboard", 0), // index 0
          _item(Icons.upload_file, "Upload Questions", 1), // index 1
          _item(Icons.assignment, "Evaluate Sheets", 2), // index 2
          _item(Icons.quiz, "Question Management", 3), // index 3
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, int index) {
    final active = index == currentIndex;

    return GestureDetector(
      onTap: () => onChanged(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: active ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? Colors.white : Colors.grey),
            const SizedBox(width: 14),

            // ✅ FIX: Wrapped in Expanded to prevent overflow
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: active ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                overflow:
                    TextOverflow.ellipsis, // Adds "..." if text is too long
                maxLines: 1, // Ensures it stays on one line
              ),
            ),
          ],
        ),
      ),
    );
  }
}
