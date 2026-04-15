import 'package:dio/dio.dart';
import 'package:my_project/core/token_store.dart';

class ApiClient {
  final TokenStore tokenStore;
  bool _isRefreshing = false;
  late Dio dio;

  ApiClient({required this.tokenStore}) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.0.104:8000',
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
            if (!_isRefreshing) {
              _isRefreshing = true;
              await _refreshToken();
              _isRefreshing = false;
            }

            final options = e.requestOptions;

            options.headers['Authorization'] = 
                'Bearer ${tokenStore.accessToken}';

            final response = await dio.fetch<dynamic>(options);
            return handle.resolve(response);
          } catch (error) {
            _isRefreshing = false;
            return handle.next(e);
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

      final response = await dio.post<dynamic>(
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
      throw Exception('Token refresh failed');
    }
  }
}
