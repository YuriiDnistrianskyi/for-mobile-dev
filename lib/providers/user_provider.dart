import 'package:flutter/material.dart';
import 'package:my_project/models/user_model.dart';
import 'package:my_project/repository/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository repository;
  User? _user;

  User? get user => _user;

  UserProvider ({
    required this.repository,
  });

  Future<void> getUser(int id) async {
    _user = await repository.getById<User>('user', id, User.fromMap);
    print('-----------------------------');
    print(_user);
    print('2');
    print('-----------------------------');
    notifyListeners();
  }

  Future<bool> userExists(String email) async {
    final User? user = await repository.getUser(email);
    return user != null;
  }

  Future<void> createUser(
    String firstName,
    String lastName,
    String email,
    String password
  ) async { 
    final User newUser = User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password
    );

    await repository.insert<User>(newUser, User.fromMap);
  }

  Future<void> updateUser(
    int id,
    String firstName,
    String lastName,
    String email,
    String password
  ) async {
    final User newUser = User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password
    );

    await repository.update(newUser, id);
  }

  Future<void> deleteUser(int id) async {
    await repository.delete('user', id);
  }
}
