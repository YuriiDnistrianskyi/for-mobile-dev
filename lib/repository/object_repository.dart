import 'package:my_project/models/object_model.dart';
import 'package:my_project/repository/general_repository.dart';

class ObjectRepository extends GeneralRepository {
  ObjectRepository({required super.db, required super.api});

  Future<List<MyObject>> getObjectsByUserId(int userId) async {
    try {
      final data = await api.get('object/user/$userId/');

      final list = (data as List)
          .map((e) => MyObject.fromMap(e as Map<String, dynamic>))
          .toList();

      for (var obj in list) {
        await insertInDb(obj);
      }

      return list;
    } catch (e) {
      final List<Map<String, Object?>> objects = await db.query(
        'object',
        where: 'userId = ?',
        whereArgs: [userId]
      );
      final List<MyObject> result = objects.map(MyObject.fromMap).toList();
      return result;
    }
  }

  Future<MyObject?> getObjectByPrivateName(String privateName) async {
    try {
      final data = await api.get('object/by-private-name/$privateName');

      final object = MyObject.fromMap(data['obj'] as Map<String, dynamic>);

      await insertInDb(object);

      return object;
    } catch (e) {
      final List<Map<String, dynamic>> objects = await db.query(
      'object',
      where: 'privateName = ?',
      whereArgs: [privateName],
      );
      if (objects.isNotEmpty) {
        return MyObject.fromMap(objects.first);
      }
      return null;
    }
  }
}
