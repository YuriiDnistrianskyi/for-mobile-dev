class AuthState{
  final bool isLoggin;
  final int? userId;
  final bool isLoading;
  final String? error;

  AuthState({
    required this.isLoggin,
    required this.isLoading,
    this.userId,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoggin: false,
      isLoading: false
    );
  }

  AuthState copyWith({
    bool? isLoggin,
    int? userId,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggin: isLoggin ?? this.isLoggin,
      userId: userId ?? this.userId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  AuthState copyRemoveUserId() {
    return AuthState(
      isLoggin: isLoggin, 
      isLoading: isLoading,
      error: error
    );
  }
}
