import 'package:my_project/models/i_model.dart';

class SpeedGraphPoint extends IModel {
  final int deviceId;
  final int time;
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
        time: map['time'] as int,
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
