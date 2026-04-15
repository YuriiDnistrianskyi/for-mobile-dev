import 'package:my_project/models/i_model.dart';

abstract class ILocalRepository {

  Future<void> insert(IModel obj);
  Future<IModel> insertInDb(IModel obj);
  Future<List<T>> get<T>(
    String table,
    T Function(Map<String, dynamic>) fromMap,
  );
  Future<T?> getById<T>(
    String table, 
    int id,
    T Function(Map<String, dynamic>) fromMap,  
  );
  Future<bool> modelExists(String table, String privateName);
  Future<int> delete(String table, int id);
  Future<int> update(IModel obj, int id);

  Future<void> close();
}
