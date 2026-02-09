import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../core/app_colors.dart';
import '../../services/ai_recommendation_service.dart';
import '../../services/ai_tutor_service.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Services
  final AIRecommendationService _recommendationService =
      AIRecommendationService();
  final AITutorService _tutorService = AITutorService();

  // State
  List<Map<String, String>> _messages =
      []; // { "role": "user" | "ai", "text": "..." }
  bool _isLoading = true;
  bool _isSending = false;
  String _targetSubject = "General";

  @override
  void initState() {
    super.initState();
    _initializeTutor();
  }

  /// 1. Fetch User Weakness & Prime the AI
  Future<void> _initializeTutor() async {
    try {
      // Replace with actual User ID
      String userId = "CURRENT_USER_ID";

      // Fetch Recommendation (e.g., {subject: "Chemistry", level: "Hard"})
      final data = await _recommendationService.getRecommendation(userId);
      _targetSubject = data['subject'];
      String level = data['level'];

      // Init AI with this context
      _tutorService.initSession(_targetSubject, level);

      // Add Initial Greeting
      setState(() {
        _messages.add({
          "role": "ai",
          "text":
              "Hi! I noticed you're working on **$_targetSubject** ($level). "
              "I'm here to help you master it! Ask me a question.",
        });
        _isLoading = false;
      });
    } catch (e) {
      // Fallback if no analytics found
      _tutorService.initSession("General Studies", "Medium");
      setState(() {
        _messages.add({
          "role": "ai",
          "text":
              "Hello! I'm your AI Tutor. What subject are we studying today?",
        });
        _isLoading = false;
      });
    }
  }

  /// 2. Handle Sending Messages
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Add User Message
    setState(() {
      _messages.add({"role": "user", "text": text});
      _isSending = true;
      _controller.clear();
    });
    _scrollToBottom();

    // Get AI Response
    final response = await _tutorService.sendMessage(text);

    // Add AI Message
    setState(() {
      _messages.add({"role": "ai", "text": response});
      _isSending = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Handling Keyboard overlapping
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85, // Taller view
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            /// ===== HEADER =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.psychology,
                    color: Colors.white,
                  ), // Brain Icon
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personalized Tutor",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _isLoading ? "Analyzing..." : "Focus: $_targetSubject",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            /// ===== CHAT AREA =====
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length + (_isSending ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return const _TypingIndicator(); // Show when AI is thinking
                        }

                        final msg = _messages[index];
                        final isUser = msg['role'] == 'user';

                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? AppColors.softGreen
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isUser
                                    ? const Radius.circular(16)
                                    : Radius.zero,
                                bottomRight: isUser
                                    ? Radius.zero
                                    : const Radius.circular(16),
                              ),
                            ),
                            child: isUser
                                ? Text(
                                    msg['text']!,
                                    style: const TextStyle(color: Colors.white),
                                  )
                                : MarkdownBody(
                                    data: msg['text']!,
                                  ), // Render Markdown
                          ),
                        );
                      },
                    ),
            ),

            /// ===== INPUT AREA =====
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: "Ask about $_targetSubject...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.softGreen,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: const SizedBox(
          width: 40,
          child: LinearProgressIndicator(minHeight: 2),
        ),
      ),
    );
  }
}
