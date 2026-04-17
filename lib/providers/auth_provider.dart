import 'package:flutter/material.dart';
// import 'package:my_project/models/user_model.dart';
import 'package:my_project/core/token_store.dart';
import 'package:my_project/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final UserRepository repository;
  late int? _userId;
  int? get userId => _userId;

  final TokenStore tokenStore;

  AuthProvider({required this.repository, required this.tokenStore});

  bool _isLoggin = false;
  bool get isLoggin => _isLoggin;

  Future<void> login(String email, String password) async {
    try {
      final response = await repository.login(email, password);
      tokenStore.accessToken = response['access_token'] as String;
      tokenStore.refreshToken = response['refresh_token'] as String;
      _userId = response['user_id'] as int;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('__accessToken', tokenStore.accessToken as String);
      await prefs.setString(
        '__refreshToken',
        tokenStore.refreshToken as String,
      );
      await prefs.setInt('__userId', _userId as int);

      _isLoggin = true;

      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('__accessToken');
    final refreshToken = prefs.getString('__refreshToken');
    final userId = prefs.getInt('__userId');

    if (accessToken == null || refreshToken == null || userId == null) return;

    _isLoggin = true;
    tokenStore.accessToken = accessToken;
    tokenStore.refreshToken = refreshToken;
    _userId = userId;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggin = false;
    tokenStore.accessToken = null;
    tokenStore.refreshToken = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('__accessToken');
    await prefs.remove('__refreshToken');
    await prefs.remove('__userId');
    await repository.delete('user', _userId!);
    notifyListeners();
  }
}
