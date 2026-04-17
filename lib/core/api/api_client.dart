import 'dart:async';
import 'package:dio/dio.dart';
import 'package:my_project/core/token_store.dart';

class ApiClient {
  final _authController = StreamController<bool>.broadcast();
  Stream<bool> get authStream => _authController.stream;

  final TokenStore tokenStore;
  Future<void>? _refreshFuture;

  late Dio dio;
  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: 'http://10.143.61.82:8000',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  ApiClient({required this.tokenStore}) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.143.61.82:8000',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Content-Type': 'application/json',
        }
      )
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = tokenStore.accessToken;

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },

        onResponse: (response, handler) {
          return handler.next(response);
        },

        onError: (DioException e, handle) async {
          if (e.response?.statusCode != 401) {
            return handle.next(e);
          }

          if (e.requestOptions.path.contains('/auth/refresh')) {
            return handle.next(e);
          }

          try {
            _refreshFuture ??= _refreshToken();

            await _refreshFuture;
            _refreshFuture = null;

            final options = e.requestOptions;

            options.headers['Authorization'] = 
                'Bearer ${tokenStore.accessToken}';

            final response = await dio.request<dynamic>(
              options.path,
              data: options.data,
              queryParameters: options.queryParameters,
              options: Options(
                method: options.method,
                headers: {
                  ...options.headers,
                  'Authorization': 'Bearer ${tokenStore.accessToken}',
                }
              )
            );

            return handle.resolve(response);
          } catch (error) {
            _refreshFuture = null;

            tokenStore.accessToken = null;
            tokenStore.refreshToken = null;

            _authController.add(false);
          }
        }
      )
    );
  }

  Future<void> _refreshToken() async {
    try {
      if (tokenStore.refreshToken == null) {
        throw Exception('No refresh token');
      }

      final response = await _refreshDio.post<dynamic>(
        '/auth/refresh',
        data: {
          'refresh_token': tokenStore.refreshToken,
        }
      );

      tokenStore.accessToken = response.data['access_token'] as String;
      tokenStore.refreshToken = response.data['refresh_token'] as String;
    } catch (error) {
      tokenStore.accessToken = null;
      tokenStore.refreshToken = null;
      throw Exception('Token refresh failed: $error');
    }
  }
}
