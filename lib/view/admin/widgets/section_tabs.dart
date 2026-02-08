import 'package:flutter/material.dart';

class SectionTabs extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChanged;
  final List<String> tabs;

  const SectionTabs({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        final active = index == currentIndex;
        return GestureDetector(
          onTap: () => onChanged(index),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: active ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(.06)),
              ],
            ),
            child: Text(
              tabs[index],
              style: TextStyle(
                color: active ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }
}
