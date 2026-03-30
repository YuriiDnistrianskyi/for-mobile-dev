abstract class IModel {
  String getTableName();

  IModel();

  IModel.fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();
}
