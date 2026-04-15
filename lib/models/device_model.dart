import 'package:my_project/models/i_model.dart';

class Device extends IModel {
  final int? id;
  final String publicName;
  final String privateName;
  final String? password;
  final int objectId;

  Device({
    required this.publicName,
    required this.privateName,
    required this.objectId,
    this.password,
    this.id,
  });

  @override
  factory Device.fromMap(Map<String, dynamic> map) => Device(
    id: int.parse(map['id'].toString()),
    publicName: map['publicName'] as String,
    privateName: map['privateName'] as String,
    objectId: int.parse(map['objectId'].toString()),
  );

  @override
  String getTableName() => 'device';

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'publicName': publicName,
      'privateName': privateName,
      'objectId': objectId,
    };
    return data;
  }
}
