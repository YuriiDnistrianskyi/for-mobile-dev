import 'package:my_project/local_server/models/i_model.dart';

class SpeedGraphPointModel extends IModel {
  final int deviceId;
  final DateTime time;
  final int value;

  SpeedGraphPointModel({
    required this.deviceId,
    required this.time,
    required this.value,
  });

  @override
  IModel fromMap(Map<String, dynamic> map) =>
    SpeedGraphPointModel(
      deviceId: map['daviceId'] as int,
      time: map['time'] as DateTime,
      value: map['value'] as int,
    );

  @override
  String getTableName() => 'SpeedGraphPoint';

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'deviceId': deviceId,
      'time': time,
      'value': value,
    };
    return data;
  }
}
