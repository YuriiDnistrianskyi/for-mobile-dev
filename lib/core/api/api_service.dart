import 'package:dio/dio.dart';
import 'package:my_project/core/api/api_client.dart';


class ApiService {
  final Dio _dio = ApiClient().dio;

  Future<dynamic> get(String path) async {
    try {
      final response = await _dio.get<dynamic>(path);
      return response.data;
    } catch (e) {
      throw Exception('GET error');
    }
  }

  Future<dynamic> post(String path, dynamic data) async {
    try {
      final response = await _dio.post<dynamic>(path, data: data);
      return response.data;
    } catch (e) {
      throw Exception('POST error');
    }
  }

  Future<dynamic> patch(String path, dynamic data) async {
    try {
      final response = await _dio.patch<dynamic>(path, data: data);
      return response.data;
    } catch (e) {
      throw Exception('PATCH error');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete<dynamic>(path);
      return response.data;
    } catch (e) {
      throw Exception('DELETE error');
    }
  }
}
