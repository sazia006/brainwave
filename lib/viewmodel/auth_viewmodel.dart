import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLogin = true;

  void toggle() {
    isLogin = !isLogin;
    notifyListeners();
  }
}
