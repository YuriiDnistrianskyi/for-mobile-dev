class GraphPoint {
  final DateTime time;
  final double value;

  GraphPoint({required this.time, required this.value});

  factory GraphPoint.fromMap(Map<String, dynamic> map) => GraphPoint(
      time: map['time'] as DateTime,
      value: map['value'] as double,
  );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'time': time,
      'value': value,
    };
    return data;
  }
}
