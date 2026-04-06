import 'package:my_project/models/device_model.dart';
import 'package:my_project/models/i_model.dart';
import 'package:my_project/models/object_model.dart';
import 'package:my_project/models/user_model.dart';

abstract class ILocalRepository {
  Future<void> open(String path);

  Future<IModel> insert(IModel obj);
  Future<List<T>> get<T>(
    String table,
    T Function(Map<String, dynamic>) fromMap,
  );
  Future<T?> getById<T>(
    String table, 
    int id,
    T Function(Map<String, dynamic>) fromMap,  
  );
  Future<User?> getUser(String email);
  Future<List<MyObject>> getObjectsByUserId(int userId);
  Future<MyObject?> getObjectByPrivateName(String privateName);
  Future<Device?> getDeviceByPrivateName(String privateName);
  Future<List<Device>> getDevicesByObjectId(int objectId);
  Future<List<T>> getGraph<T> (
    String table, 
    String columnId,
    int id,
    T Function(Map<String, dynamic>) fromMap
  );
  Future<T> getLastPoint<T> (
    int id,
    String columnId,
    String table,
    T Function(Map<String, dynamic>) fromMap
  );
  Future<void> trimTable(String table, String column, int byId);
  Future<bool> modelExists(String table, String privateName);
  Future<int> delete(String table, int id);
  Future<int> update(IModel obj, int id);

  Future<void> close();
}
