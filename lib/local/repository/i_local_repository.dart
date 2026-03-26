import 'package:my_project/local/models/i_model.dart';
import 'package:my_project/local/models/user_model.dart';


abstract class ILocalRepository {
  Future<void> open(String path);

  Future<IModel> insert(IModel obj);
  Future<List<IModel>> get(IModel obj);
  Future<IModel?> getById(IModel table, int id);
  Future<User?> getUser(String email);
  Future<int> delete(String table, int id);
  Future<int> update(IModel obj, int id);

  Future<void> close();
}
