import 'package:my_project/local_server/models/i_model.dart';


abstract class ILocalRepository {
  Future<void> open(String path);

  Future<IModel> insert(IModel obj);
  Future<List<IModel>> get(IModel obj);
  Future<IModel?> getById(IModel table, int id);
  Future<int> delete(String table, int id);
  Future<int> update(IModel obj, int id);

  Future<void> close();
}
