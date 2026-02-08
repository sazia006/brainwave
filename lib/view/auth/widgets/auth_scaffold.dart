import 'package:flutter/material.dart';

import '../../../core/image_path.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child; // main page body (scrollable)
  final Widget? footer; // pinned bottom widget (optional)
  final bool showBackButton;

  const AuthScaffold({
    super.key,
    required this.child,
    this.footer,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF4E8), // light orange background
      body: SafeArea(
        child: Column(
          children: [
            // Top Row: Back Button
            if (showBackButton)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

            const SizedBox(height: 8),

            // Logo Centered
            Center(
              child: Column(
                children: [
                  Image.asset(
                    ImagePath.logo, // your app logo path
                    height: 60,
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      "BrainWave",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Main scrollable body - takes available space
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: child,
              ),
            ),

            // Footer pinned at bottom if provided
            if (footer != null) ...[
              const SizedBox(height: 12),
              footer!,
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
