import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http; // Use http for API calls

class OtpService {
  final _db = FirebaseFirestore.instance;

  // 🔴 REPLACE THESE WITH YOUR ACTUAL KEYS FROM EMAILJS DASHBOARD
  final String _serviceId = "service_brainwave_gmail";
  final String _templateId = "template_ufgl3go";
  final String _publicKey = "l_9Il6rdOb3tNn2oI";

  String _generateOtp() {
    // Generates a 6-digit random number
    return (100000 + Random().nextInt(900000)).toString();
  }

  Future<void> sendOtp(String uid, String email) async {
    final otp = _generateOtp();

    // 1. Save OTP to Firestore (for verification logic)
    await _db.collection("otp").doc(uid).set({
      "code": otp,
      "expiresAt": DateTime.now().add(const Duration(minutes: 5)),
    });

    // 2. Send Email via EmailJS API
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost', // Often required by EmailJS
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'to_email':
                email, // Ensure your EmailJS template uses {{to_email}} in the "To Email" field!
            'otp_code': otp, // Must match {{otp_code}} in your template body
          },
        }),
      );

      if (response.statusCode == 200) {
        print("✅ OTP Email Sent Successfully to $email");
      } else {
        print("❌ Failed to send OTP: ${response.body}");
      }
    } catch (e) {
      print("❌ Error calling EmailJS: $e");
    }
  }

  // Verify OTP (Remains the same)
  Future<bool> verifyOtp(String uid, String input) async {
    final snap = await _db.collection("otp").doc(uid).get();
    if (!snap.exists) return false;

    // Check code match
    if (snap["code"] != input) return false;

    // Check expiration
    final expires = (snap["expiresAt"] as Timestamp).toDate();
    if (DateTime.now().isAfter(expires)) return false;

    // Mark user as verified
    await _db.collection("users").doc(uid).update({"verified": true});

    // Delete OTP document to prevent reuse
    await _db.collection("otp").doc(uid).delete();
    return true;
  }
}
