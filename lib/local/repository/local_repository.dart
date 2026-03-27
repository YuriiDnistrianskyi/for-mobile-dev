// import 'package:my_project/local_server/models/device_model.dart';
import 'package:my_project/local/models/i_model.dart';
import 'package:my_project/local/models/object_model.dart';
// import 'package:my_project/local_server/models/temperature_graph_point_model.dart';
import 'package:my_project/local/models/user_model.dart';
import 'package:my_project/local/repository/i_local_repository.dart';
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
            privatName text not null,
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
            privatName text not null,
            password text not null,
            objectId integer references object(id)
          )
          ''';

const String createTemperatureGraphPointTable = '''
          create table temperatureGraphPoint(
            objectId integer references object(id),
            time datetime not null,
            value float not null
          )
          ''';

const String createSpeedGraphPointTable = '''
          create table speedGraphPoint(
            deviceId integer references device(id),
            time datetime not null,
            value float not null
          )
          ''';

class Repository implements ILocalRepository {
  late Database db;

  @override
  Future<void> open(String path) async {
    db = await openDatabase(
      path,
      version: 1, 
      onCreate: (Database db, int version) async {
        await db.execute(createUserTable);
        await db.execute(createObjectTable);
        await db.execute(createDeviceTable);
        await db.execute(createTemperatureGraphPointTable);
        await db.execute(createSpeedGraphPointTable);
      }
    );
  }

  @override
  Future<IModel> insert(IModel obj) async {
    final String table = obj.getTableName(); 
    await db.insert(table, obj.toMap());
    return obj;
  }

  @override
  Future<List<T>> get<T>(
    String table, 
    T Function(Map<String, dynamic>) fromMap
  ) async {
    final List<Map<String, Object?>> maps = await db.query(table);
    final List<T> list = maps.map(fromMap).toList();
    return list;
  }

  @override
  Future<T?> getById<T>(
    String table,
    int id,
    T Function(Map<String, dynamic>) fromMap  
  ) async {
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

  @override
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

  @override
  Future<List<MyObject>> getObjectsByUserId(int userId) async{
    final List<Map<String, Object?>> objects = await db.query(
      'object',
      where: 'user_id = ?',
      whereArgs: [userId]
    );
    final List<MyObject> list = objects.map(MyObject.fromMap).toList();
    return list;
  }

  @override
  Future<int> update(IModel obj, int id) async {
    return await db.update(
      obj.getTableName(), 
      obj.toMap(), where: 
      'id = ?', 
      whereArgs: [id],
      );
  }

  @override
  Future<int> delete(String table, int id) async {
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> close() async => db.close();
}
