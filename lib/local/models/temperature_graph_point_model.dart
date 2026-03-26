import 'package:my_project/local/models/i_model.dart';

class TemperatureGraphPoint extends IModel {
  final int objectId;
  final DateTime time;
  final double value;

  TemperatureGraphPoint({
    required this.objectId,
    required this.time,
    required this.value,
  });

  @override
  factory TemperatureGraphPoint.fromMap(Map<String, dynamic> map) =>
      TemperatureGraphPoint(
        objectId: map['objectId'] as int,
        time: map['time'] as DateTime,
        value: map['value'] as double,
      );

  @override
  String getTableName() => 'temperatureGraphPoint';

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'object_id': objectId,
      'time': time,
      'value': value,
    };
    return data;
  }
}
