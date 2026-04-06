import 'package:flutter/material.dart';
import 'package:my_project/models/temperature_graph_point_model.dart';
import 'package:my_project/repository/local_repository.dart';
import 'package:my_project/services/mqtt_service.dart';

class TemperatureGraphProvider extends ChangeNotifier {
  final Repository repository;
  final Map<int, List<TemperatureGraphPoint>> _graphs = {};
  final Map<int, TemperatureGraphPoint?> _lastPoints = {};

  TemperatureGraphProvider({required this.repository});

  List<TemperatureGraphPoint> getGraph(int objectId) {
    return _graphs[objectId] ?? [];
  }

  TemperatureGraphPoint? getLastPoint(int objectId) {
    return _lastPoints[objectId] ??
        TemperatureGraphPoint(
          objectId: objectId,
          time: DateTime.now().millisecondsSinceEpoch,
          value: 0,
        );
  }

  void listen(MqttService service) {
    service.manager.stream.listen((message) async {
      final topic = message['topic'] as String;
      final payload = message['payload'];

      if (topic.split('/')[0] == 'object') {
        final object = await repository.getObjectByPrivateName(
          topic.split('/')[1],
        );

        if (object != null) {
          await createTemperaturePoint(
            object.id!,
            double.parse(payload as String),
          );
          await getLastTemperatureGraphPoint(object.id!);
          await getTemperatureGraph(object.id!);
        }
      }
    });
  }

  Future<void> getTemperatureGraph(int objectId) async {
    final List<TemperatureGraphPoint> graph = await repository.getGraph(
      'temperatureGraphPoint',
      'objectId',
      objectId,
      TemperatureGraphPoint.fromMap,
    );
    _graphs[objectId] = graph;
    notifyListeners();
  }

  Future<void> getLastTemperatureGraphPoint(int objectId) async {
    final TemperatureGraphPoint? lastPoint = await repository.getLastPoint(
      objectId,
      'objectId',
      'temperatureGraphPoint',
      TemperatureGraphPoint.fromMap,
    );
    _lastPoints[objectId] = lastPoint;
    notifyListeners();
  }

  Future<void> createTemperaturePoint(int objectId, double value) async {
    final TemperatureGraphPoint point = TemperatureGraphPoint(
      objectId: objectId,
      time: DateTime.now().millisecondsSinceEpoch,
      value: value,
    );
    await repository.insert(point);
    // await repository.trimTable('temperatureGraphPoint', 'objectId', objectId);
    notifyListeners();
  }
}
