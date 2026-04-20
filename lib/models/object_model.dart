import 'package:my_project/models/i_model.dart';

class MyObject extends IModel {
  final int? id;
  final String publicName;
  final String privateName;
  final String? password;
  final int userId;
  final double maxTemperature;
  final int defaultSpeedForDevices;

  MyObject({
    required this.publicName,
    required this.privateName,
    required this.userId,
    required this.maxTemperature,
    required this.defaultSpeedForDevices,
    this.password,
    this.id,
  });

  @override
  factory MyObject.fromMap(Map<String, dynamic> map) => MyObject(
    id: int.parse(map['id'].toString()),
    publicName: map['publicName'] as String,
    privateName: map['privateName'] as String,
    userId: int.parse(map['userId'].toString()),
    maxTemperature: double.parse(map['maxTemperature'].toString()),
    defaultSpeedForDevices: map['defaultSpeedForDevices'] as int,
  );

  @override
  String getTableName() => 'object';

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'publicName': publicName,
      'privateName': privateName,
      'password': password,
      'userId': userId,
      'maxTemperature': maxTemperature,
      'defaultSpeedForDevices': defaultSpeedForDevices,
    };
    return data;
  }
}
