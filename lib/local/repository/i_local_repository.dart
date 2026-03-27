import 'package:my_project/local/models/device_model.dart';
import 'package:my_project/local/models/i_model.dart';
import 'package:my_project/local/models/object_model.dart';
import 'package:my_project/local/models/user_model.dart';

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
  Future<List<Device>> getDevicesByObjectIs(int objectId);
  Future<int> delete(String table, int id);
  Future<int> update(IModel obj, int id);

  Future<void> close();
}
