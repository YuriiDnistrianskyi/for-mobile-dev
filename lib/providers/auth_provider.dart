import 'package:flutter/material.dart';
import 'package:my_project/local/repository/local_repository.dart';

class AuthProvider with ChangeNotifier {
  final Repository repository;
  bool _isLoggin = false;

  AuthProvider({
    required this.repository,
  });

  bool get isLoggin => _isLoggin;

  void login() {
    setState() {
      _isLoggin = true;
    }
    // _isLoggin = true;
    notifyListeners();
  }

  void logout() {
    _isLoggin = false;
    notifyListeners();
  }
}
