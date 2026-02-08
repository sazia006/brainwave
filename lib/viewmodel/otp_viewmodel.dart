import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/otp_service.dart';

class OtpViewModel extends ChangeNotifier {
  final OtpService _otpService = OtpService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- Timer State ---
  int _secondsRemaining = 300;
  Timer? _timer;
  int get secondsRemaining => _secondsRemaining;

  // --- Loading & Error State ---
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Constructor starts timer immediately
  OtpViewModel() {
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        _secondsRemaining--;
        notifyListeners();
      }
    });
  }

  // --- Verification Logic ---
  // We accept an optional 'email' to handle the Forgot Password flow (where user isn't logged in)
  Future<bool> verifyOtp(String code, {String? email}) async {
    _setLoading(true);
    _errorMessage = null;

    String? uid = _auth.currentUser?.uid;

    // 1. If user is NOT logged in (Forgot Password), find UID by Email
    if (uid == null && email != null) {
      uid = await _fetchUidByEmail(email);
    }

    // 2. If we still don't have a UID, we can't verify
    if (uid == null) {
      _errorMessage = "User not found or session expired.";
      _setLoading(false);
      return false;
    }

    // 3. Call Service to Verify
    final isValid = await _otpService.verifyOtp(uid, code);

    if (!isValid) {
      _errorMessage = "Invalid or expired OTP";
    }

    _setLoading(false);
    return isValid;
  }

  // Helper to find UID if user is not logged in
  Future<String?> _fetchUidByEmail(String email) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        return snap.docs.first.id;
      }
    } catch (e) {
      // ignore error
    }
    return null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
