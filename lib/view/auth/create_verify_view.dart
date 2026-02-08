import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'widgets/auth_scaffold.dart';
import '../auth/success_view.dart';

class CreateVerifyView extends StatefulWidget {
  const CreateVerifyView({super.key, required String email});

  @override
  State<CreateVerifyView> createState() => _CreateVerifyViewState();
}

class _CreateVerifyViewState extends State<CreateVerifyView> {
  String? selectedGroup;
  bool loading = false;

  final List<String> groups = ["Science", "Arts", "Commerce"];

  Future<void> saveGroup() async {
    if (selectedGroup == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select your group")));
      return;
    }

    setState(() => loading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "group": selectedGroup,
      "updatedAt": Timestamp.now(),
    }, SetOptions(merge: true));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const SuccessView(message: "Account Created Successfully!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Your Group",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              "This helps us personalize your learning experience",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// 🔽 GROUP DROPDOWN
            DropdownButtonFormField<String>(
              value: selectedGroup,
              hint: const Text("Select HSC Group"),
              items: groups
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedGroup = value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFFF3E8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF7941D)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ✅ SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : saveGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7941D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Continue →",
                        style: TextStyle(color: Colors.black),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
