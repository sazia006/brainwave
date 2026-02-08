import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Ensure this is imported

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
    this.icon, // Changed from iconPath to icon
    this.textColor,
    this.isActive,
  });

  final String title;
  final Color backgroundColor;
  final VoidCallback onTap; // specific type for void functions
  final IconData? icon; // Changed type to accept FontAwesomeIcons
  final Color? textColor;
  final dynamic isActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.maxFinite,
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center, // Ensures content is centered
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.black,
                ),
              ),
              // Render Icon if provided
              if (icon != null) ...[
                const SizedBox(width: 10), // Spacing between text and icon
                FaIcon(
                  icon,
                  size: 18,
                  color: textColor ?? Colors.black, // Match text color
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
