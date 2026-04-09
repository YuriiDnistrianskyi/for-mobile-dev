import 'package:flutter/material.dart';
import 'package:my_project/models/user_model.dart';
import 'package:my_project/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final UserRepository repository;
  late int _userId;
  int get userId => _userId;

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
    _userId = user.id!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('__userId', user.id!);
    notifyListeners();

    return user.id!; //
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('__userId');
    if (userId == null) return;
    _isLoggin = true;
    _userId = userId;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggin = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('__userId');
    notifyListeners();
  }
}
