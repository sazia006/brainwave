import 'package:flutter/material.dart';
import '../view/chatbot/chatbot_view.dart';
import '../core/app_colors.dart';

class ChatBotFAB extends StatelessWidget {
  const ChatBotFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.softGreen,
      child: const Icon(Icons.smart_toy),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const ChatBotView(),
        );
      },
    );
  }
}
