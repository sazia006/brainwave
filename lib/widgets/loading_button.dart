import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final bool loading;
  final String text;
  final VoidCallback onTap;

  const LoadingButton({
    super.key,
    required this.loading,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(text),
      ),
    );
  }
}
