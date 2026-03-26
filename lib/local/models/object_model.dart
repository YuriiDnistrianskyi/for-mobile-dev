import 'package:my_project/local/models/i_model.dart';

class _Object extends IModel {
  final int id;
  final String publicName;
  final String privateName;
  final String password;
  final int userId;
  final double maxTemperature;
  final int defaultSpeedForDevices;

  _Object({
    required this.id,
    required this.publicName,
    required this.privateName,
    required this.password,
    required this.userId,
    required this.maxTemperature,
    required this.defaultSpeedForDevices,
  });

  @override
  factory _Object.fromMap(Map<String, dynamic> map) => _Object(
    id: map['id'] as int,
    publicName: map['publicName'] as String,
    privateName: map['privateName'] as String,
    password: map['password'] as String,
    userId: map['userId'] as int,
    maxTemperature: map['maxTemperature'] as double,
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
