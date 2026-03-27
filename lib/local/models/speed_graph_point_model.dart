import 'package:my_project/local/models/i_model.dart';

class SpeedGraphPoint extends IModel {
  final int deviceId;
  final DateTime time;
  final int value;

  SpeedGraphPoint({
    required this.deviceId,
    required this.time,
    required this.value,
  });

  @override
  factory SpeedGraphPoint.fromMap(Map<String, dynamic> map) =>
      SpeedGraphPoint(
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
