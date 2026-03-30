import 'package:flutter/material.dart';
import 'package:my_project/local/models/temperature_graph_point_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class TemperatureGraphProvider extends ChangeNotifier {
  final Repository repository;
  final Map<int, List<TemperatureGraphPoint>> _graphs = {};
  final Map<int, TemperatureGraphPoint?> _lastPoints = {};

  TemperatureGraphProvider({required this.repository});

  List<TemperatureGraphPoint> getGraph(int objectId) {
    return _graphs[objectId] ??
        [
          TemperatureGraphPoint(
            objectId: objectId,
            time: DateTime.now(),
            value: 20,
          ),
          TemperatureGraphPoint(
            objectId: objectId,
            time: DateTime.now(),
            value: 22,
          ),
          TemperatureGraphPoint(
            objectId: objectId,
            time: DateTime.now(),
            value: 21,
          ),
          TemperatureGraphPoint(
            objectId: objectId,
            time: DateTime.now(),
            value: 23,
          ),
          TemperatureGraphPoint(
            objectId: objectId,
            time: DateTime.now(),
            value: 24,
          ),
        ];
      // для тесту щоб був графік

  }

  TemperatureGraphPoint? getLastPoint(int objectId) {
    return _lastPoints[objectId];
  }

  Future<void> getTemperatureGraph(int objectId) async {
    final List<TemperatureGraphPoint> graph = await repository.getGraph(
      'speedGraphPoint',
      'object_id',
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
}
