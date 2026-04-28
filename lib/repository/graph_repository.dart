import 'package:my_project/models/i_model.dart';
import 'package:my_project/repository/general_repository.dart';

class GraphRepository extends GeneralRepository {
  GraphRepository({required super.db, required super.api});

  @override
  Future<void> insert<T>(
    IModel obj, 
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    // final table = obj.getTableName();
    // final data = await api.post('/$table/', obj.toMap());
    // final newObj = fromMap(data['obj'] as Map<String, dynamic>);
    await insertInDb(obj);
  }

  Future<List<T>> getGraph<T> (
    String table,
    String columnId,
    int id,
    T Function(Map<String, dynamic>) fromMap
  ) async {
    final List<Map<String, Object?>> graph = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
      limit: 50
    );
    final List<T> result = graph.map(fromMap).toList();
    return result;
  }

  Future<T?> getLastPoint<T> (
    int id,
    String columnId,
    String table,
    T Function(Map<String, dynamic>) fromMap
  ) async {
    final List<Map<String, Object?>> list = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
      orderBy: 'time DESC',
      limit: 1,
    );
    if (list.isEmpty) return null;
    final T point = fromMap(list.first);
    return point;
  }

  Future<void> trimTable(String table, String column, int byId) async {
    await db.rawDelete('''
    DELETE FROM $table
    WHERE id NOT IN (
      SELECT id FROM $table
      WHERE $column = ?
      ORDER BY time DESC
      LIMIT 100
    )
    AND $column = ?
    ''', [byId, byId]);
  }
}
