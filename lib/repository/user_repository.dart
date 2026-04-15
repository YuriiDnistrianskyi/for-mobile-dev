import 'package:my_project/models/user_model.dart';
import 'package:my_project/repository/general_repository.dart';
// import 'package:sqflite/sqflite.dart';

class UserRepository extends GeneralRepository {
  UserRepository({
    required super.db,
    required super.api,
  });

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final data = await api.post('/auth/login', 
        {
          'email': email,
          'password': password,
        }
      );
      return data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Login -: $e');
    }
  }
 
  Future<User?> getUser(String email) async {
    final List<Map<String, Object?>> maps = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email]
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}
