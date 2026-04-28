import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/core/api/api_client.dart';
import 'package:my_project/core/token_store.dart';
import 'package:my_project/cubit/auth/auth_state.dart';
import 'package:my_project/repository/user_repository.dart';
import 'package:my_project/services/mqtt_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository repository;
  final TokenStore tokenStore;
  final ApiClient apiClient;
  final MqttService mqttService;

  AuthCubit({
    required this.repository, 
    required this.tokenStore,
    required this.apiClient,
    required this.mqttService,
  }) : super(AuthState.initial());

  void listen() {
    apiClient.authStream.listen((event) {
      if (!event) {
        logout();
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await repository.login(email, password);
      tokenStore.accessToken = response['access_token'] as String;
      tokenStore.refreshToken = response['refresh_token'] as String;
      final userId = response['user_id'] as int;
      emit(state.copyWith(userId: userId));

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('___accessToken', tokenStore.accessToken as String);
      await prefs.setString(
        '___refreshToken',
        tokenStore.refreshToken as String,
      );
      await prefs.setInt('___userId', state.userId as int);

      emit(state.copyWith(isLoggin: true, isLoading: false));
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
      throw Exception('Login failed: $ex');
    }
  }

  Future<void> autoLogin() async {
    try {
      emit(state.copyWith(isLoading: true));
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('___accessToken');
      final refreshToken = prefs.getString('___refreshToken');
      final userId = prefs.getInt('___userId');

      if (accessToken == null || refreshToken == null || userId == null) {
        emit(state.copyWith(isLoading: false, isLoggin: false));
        return;
      }

      tokenStore.accessToken = accessToken;
      tokenStore.refreshToken = refreshToken;
      emit(state.copyWith(isLoggin: true, userId: userId, isLoading: false));
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
    }
  }

  Future<void> logout() async {
    try {
      tokenStore.accessToken = null;
      tokenStore.refreshToken = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('___accessToken');
      await prefs.remove('___refreshToken');
      await prefs.remove('___userId');
      await repository.delete('user', state.userId!);
      // mqttService.removeAllSubscriptions();
      mqttService.dispose();
      emit(state.copyWith(isLoggin: false, isLoading: false));
      emit(state.copyRemoveUserId());
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
    }
  }
}
