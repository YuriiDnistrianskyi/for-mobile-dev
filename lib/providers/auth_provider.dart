import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggin = false;

  bool get isLoggin => _isLoggin;

  void login() {
    _isLoggin = true;
    notifyListeners();
  }

  void logout() {
    _isLoggin = false;
    notifyListeners();
  }
}
