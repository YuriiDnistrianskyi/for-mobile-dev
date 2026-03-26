import 'package:flutter/material.dart';
import 'package:my_project/local/models/user_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class AuthProvider with ChangeNotifier {
  final Repository repository;
  bool _isLoggin = false;

  AuthProvider({
    required this.repository,
  });

  bool get isLoggin => _isLoggin;

  Future<void> login(String email, String password) async {
    final User? user = await repository.getUser(email);
    if (user == null || user.password != password) {
      return;
    }
    _isLoggin = true;
    notifyListeners();
  }

  void logout() {
    _isLoggin = false;
    notifyListeners();
  }
}
