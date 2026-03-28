import 'package:flutter/material.dart';
import 'package:my_project/local/models/user_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class UserProvider extends ChangeNotifier {
  final Repository repository;

  UserProvider ({
    required this.repository,
  });

  Future<User?> getUser(int id) async {
    final User? user = await repository.getById<User>('user', id, User.fromMap);
    return user;
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

    await repository.insert(newUser);
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
