import 'package:my_project/local/models/i_model.dart';

class Device extends IModel {
  final int? id;
  final String publicName;
  final String privateName;
  final String password;
  final int objectId;

  Device({
    required this.publicName,
    required this.privateName,
    required this.password,
    required this.objectId,
    this.id,
  });

  @override
  factory Device.fromMap(Map<String, dynamic> map) => Device(
    id: map['id'] as int,
    publicName: map['publicName'] as String,
    privateName: map['privatName'] as String,
    password: map['password'] as String,
    objectId: map['objectId'] as int,
  );

  @override
  String getTableName() => 'device';

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'publicName': publicName,
      'privateName': privateName,
      'password': password,
      'objectId': objectId,
    };
    return data;
  }
}
