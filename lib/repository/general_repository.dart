import 'package:my_project/core/api/api_service.dart';
import 'package:my_project/models/i_model.dart';
import 'package:my_project/repository/i_local_repository.dart';
import 'package:sqflite/sqflite.dart';

const String createUserTable = '''
          create table user(
            id integer primary key autoincrement,
            firstName text not null,
            lastName text not null,
            email text not null,
            password text not null
          )
          ''';

const String createObjectTable = '''
          create table object(
            id integer primary key autoincrement,
            publicName text not null,
            privateName text not null,
            password text not null,
            userId integer references user(id),
            maxTemperature float,
            defaultSpeedForDevices integer
          )
          ''';

const String createDeviceTable = '''
          create table device(
            id integer primary key autoincrement,
            publicName text not null,
            privateName text not null,
            password text not null,
            objectId integer references object(id)
          )
          ''';

const String createTemperatureGraphPointTable = '''
          create table temperatureGraphPoint(
            id integer primary key autoincrement,
            objectId integer references object(id),
            time datetime not null,
            value float not null
          )
          ''';

const String createSpeedGraphPointTable = '''
          create table speedGraphPoint(
            id integer primary key autoincrement,
            deviceId integer references device(id),
            time datetime not null,
            value float not null
          )
          ''';

class GeneralRepository extends ILocalRepository {
  final Database db;
  final ApiService api;

  static Future<Database> open(String path) async {
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(createUserTable);
        await db.execute(createObjectTable);
        await db.execute(createDeviceTable);
        await db.execute(createTemperatureGraphPointTable);
        await db.execute(createSpeedGraphPointTable);
      },
    );

    return db;
  }

  GeneralRepository({required this.db, required this.api});

  @override
  Future<void> insert(IModel obj) async {
    final table = obj.getTableName();
    await api.post('/$table/', obj.toMap());
  }

  @override
  Future<IModel> insertInDb(IModel obj) async {
    final String table = obj.getTableName();
    await db.insert(
      table,
      obj.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return obj;
  }

  @override
  Future<List<T>> get<T>(
    String table,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    try {
      final data = await api.get('/$table/');
      final list = (data['list'] as List)
          .map((e) => fromMap(e as Map<String, dynamic>))
          .toList();

      for (var i in list) {
        await insertInDb(i as IModel);
      }

      return list;
    } catch (e) {
      final List<Map<String, Object?>> maps = await db.query(table);
      final List<T> list = maps.map(fromMap).toList();
      return list;
    }
  }

  @override
  Future<T?> getById<T>(
    String table,
    int id,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    try {
      final data = await api.get('/$table/$id');
      final obj = (data['obj'] as List)
          .map((e) => fromMap(e as Map<String, dynamic>))
          .first;

      await insertInDb(obj as IModel);

      return obj;
    } catch (e) {
      final List<Map<String, Object?>> maps = await db.query(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return fromMap(maps.first as Map<String, dynamic>);
      }
      return null;
    }
  }

  @override
  Future<bool> modelExists(String table, String privateName) async {
    final data = await api.get('/$table/exists/$privateName');
    final isExists = data['exists'] as bool;
    return isExists;
  }

  @override
  Future<int> update(IModel obj, int id) async {
    final table = obj.getTableName();
    final data = await api.patch('/$table/$id', obj.toMap());
    return (data as Map)['id'] as int;
  }

  @override
  Future<int> delete(String table, int id) async {
    await api.delete('/$table/$id');
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> close() async => db.close();
}
