import 'package:my_project/models/i_model.dart';

class TemperatureGraphPoint extends IModel {
  final int? id;
  final int objectId;
  final int time;
  final double value;

  TemperatureGraphPoint({
    required this.objectId,
    required this.time,
    required this.value,
    this.id,
  });

  @override
  factory TemperatureGraphPoint.fromMap(Map<String, dynamic> map) =>
      TemperatureGraphPoint(
        id: map['id'] as int,
        objectId: map['objectId'] as int,
        time: map['time'] as int,
        value: map['value'] as double,
      );

  @override
  String getTableName() => 'temperatureGraphPoint';

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'objectId': objectId,
      'time': time,
      'value': value,
    };
    return data;
  }
}
