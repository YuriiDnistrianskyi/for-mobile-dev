import 'package:dio/dio.dart';
// import 'package:my_project/core/api/api_client.dart';

class ApiService {
  final Dio dio;

  ApiService({required this.dio});

  Future<dynamic> get(String path) async {
    try {
      final response = await dio.get<dynamic>(path);
      return response.data;
    } catch (e) {
      throw Exception('GET error: $e');
    }
  }

  Future<dynamic> post(String path, dynamic data) async {
    try {
      final response = await dio.post<dynamic>(path, data: data);
      return response.data;
    } catch (e) {
      throw Exception('POST error: $e');
    }
  }

  Future<dynamic> patch(String path, dynamic data) async {
    try {
      final response = await dio.patch<dynamic>(path, data: data);
      return response.data;
    } catch (e) {
      throw Exception('PATCH error: $e');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await dio.delete<dynamic>(path);
      return response.data;
    } catch (e) {
      throw Exception('DELETE error: $e');
    }
  }
}
