import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Import this
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/otp_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final OtpService _otpService = OtpService();

  // State Variables
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;
  bool _isRememberMe = false;
  bool _isWrongPassword = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isRememberMe => _isRememberMe;
  bool get isWrongPassword => _isWrongPassword;

  // ✅ ADD THIS GETTER to fix the error in SignInView
  User? get user => _authService.currentUser;

  // --- UI Toggles ---
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    _isRememberMe = value;
    notifyListeners();
  }

  // --- 1. Sign Up Logic ---
  Future<bool> signUp(String name, String email, String password) async {
    _setLoading(true);

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = "Please fill in all fields.";
      _setLoading(false);
      return false;
    }

    final error = await _authService.signup(
      email: email,
      password: password,
      name: name,
    );

    if (error != null) {
      _errorMessage = error;
      _setLoading(false);
      return false;
    }

    if (_authService.currentUser != null) {
      await _otpService.sendOtp(_authService.currentUser!.uid, email);
    }

    _setLoading(false);
    return true;
  }

  // --- 2. Login Logic ---
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _isWrongPassword = false;

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Please enter email and password.";
      _setLoading(false);
      return false;
    }

    final error = await _authService.login(email, password);

    if (error != null) {
      _errorMessage = error;
      _isWrongPassword = true;
      _setLoading(false);
      return false;
    }

    _setLoading(false);
    return true;
  }

  // --- 3. Forgot Password Logic ---
  Future<bool> sendForgotPassOtp(String email) async {
    _setLoading(true);
    _errorMessage = null;

    if (email.isEmpty) {
      _errorMessage = "Please enter your email.";
      _setLoading(false);
      return false;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _errorMessage = "No account found with this email.";
        _setLoading(false);
        return false;
      }

      final uid = querySnapshot.docs.first.id;
      await _otpService.sendOtp(uid, email);

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = "Failed to process request. Please try again.";
      _setLoading(false);
      return false;
    }
  }

  // Alias to match UI call if using older method name
  Future<bool> sendPasswordResetEmail(String email) => sendForgotPassOtp(email);

  // --- 4. Reset Password Logic ---
  Future<bool> resetPassword(String newPassword, String confirmPassword) async {
    _setLoading(true);

    if (newPassword != confirmPassword) {
      _errorMessage = "Passwords do not match.";
      _setLoading(false);
      return false;
    }

    if (newPassword.length < 6) {
      _errorMessage = "Password must be at least 6 characters.";
      _setLoading(false);
      return false;
    }

    final error = await _authService.resetPasswordForUser(newPassword);

    if (error != null) {
      _errorMessage = error;
      _setLoading(false);
      return false;
    }

    _setLoading(false);
    return true;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    if (value == true) {
      _errorMessage = null;
    }
    notifyListeners();
  }
}
