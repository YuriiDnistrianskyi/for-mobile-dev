import 'package:my_project/models/user_model.dart';

class UserState {
  final User? user;
  final bool isLoading;
  final String? error;

  UserState({
    required this.isLoading,
    this.user,
    this.error
  });

  factory UserState.initial() {
    return UserState(
      isLoading: false
    );
  }

  UserState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
