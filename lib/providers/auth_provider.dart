import 'package:flutter/material.dart';
import 'package:my_project/local/models/user_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class AuthProvider with ChangeNotifier {
  final Repository repository;

  AuthProvider({
    required this.repository,
  });

  bool _isLoggin = false;
  bool get isLoggin => _isLoggin;

  Future<int> login(String email, String password) async {
    final User? user = await repository.getUser(email);
    if (user == null || user.password != password) {
      return 0;
    }
    _isLoggin = true;
    notifyListeners();
    return user.id;
  }

  void logout() {
    _isLoggin = false;
    notifyListeners();
  }
}
