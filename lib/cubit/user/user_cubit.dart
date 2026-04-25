// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/user/user_state.dart';
import 'package:my_project/models/user_model.dart';
import 'package:my_project/repository/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({
    required this.repository,
  }) : super(UserState.initial());

  Future<void> getUser(int id) async {
    try {
      emit(state.copyWith(isLoading: true));
      final user = await repository.getById<User>('user', id, User.fromMap);
      emit(state.copyWith(isLoading: false, user: user));
    } catch (ex) {
      emit (state.copyWith(error: ex.toString()));
    }
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
    getUser(id);
  }

  Future<void> deleteUser(int id) async {
    await repository.delete('user', id);
  }
}
