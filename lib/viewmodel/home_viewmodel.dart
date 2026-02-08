import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  String _userName = "Student";
  String _email = "";

  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get email => _email;

  HomeViewModel() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    final data = await _authService.getUserDetails();

    if (data != null) {
      _userName = data['name'] ?? "Student";
      _email = data['email'] ?? "";
    }

    _isLoading = false;
    notifyListeners();
  }
}
