class SpeedGraphPointModel {
  final int deviceId;
  final DateTime time;
  final int value;

  SpeedGraphPointModel({
    required this.deviceId,
    required this.time,
    required this.value,
  });

  factory SpeedGraphPointModel.fromMap(Map<String, dynamic> map) =>
    SpeedGraphPointModel(
      deviceId: map['daviceId'] as int,
      time: map['time'] as DateTime,
      value: map['value'] as int,
    );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'deviceId': deviceId,
      'time': time,
      'value': value,
    };
    return data;
  }
}
