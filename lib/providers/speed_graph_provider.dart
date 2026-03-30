import 'package:flutter/material.dart';
import 'package:my_project/local/models/speed_graph_point_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class SpeedGraphProvider extends ChangeNotifier {
  final Repository repository;
  final Map<int, List<SpeedGraphPoint>> _graphs = {};
  final Map<int, SpeedGraphPoint?> _lastPoints = {};

  SpeedGraphProvider ({
    required this.repository,
  });

  List<SpeedGraphPoint> getGraph(int deviceId) {
    return _graphs[deviceId] ?? [
      SpeedGraphPoint(deviceId: deviceId, time: DateTime.now(), value: 70), 
      SpeedGraphPoint(deviceId: deviceId, time: DateTime.now(), value: 75),
      SpeedGraphPoint(deviceId: deviceId, time: DateTime.now(), value: 80),
      SpeedGraphPoint(deviceId: deviceId, time: DateTime.now(), value: 76),
      SpeedGraphPoint(deviceId: deviceId, time: DateTime.now(), value: 95),
      ];
      // для тесту щоб був графік
  }

  SpeedGraphPoint? getLastPoint(int deviceId) {
    return _lastPoints[deviceId] ?? SpeedGraphPoint(
      deviceId: deviceId,
      time: DateTime.now(),
      value: 95,
    );
  }
 
  Future<void> getSpeedGraph(int deviceId) async {
    final List<SpeedGraphPoint> graph = await repository.getGraph(
      'speedGraphPoint', 
      'device_id', 
      deviceId, 
      SpeedGraphPoint.fromMap
    );

    _graphs[deviceId] = graph;
    notifyListeners();
  }

  Future<void> getLastSpeedGraphPoint(int deviceId) async {
    final SpeedGraphPoint? lastPoint = await repository.getLastPoint(
      deviceId, 
      'deviceId', 
      'speedGraphPoint', 
      SpeedGraphPoint.fromMap,
    );

    _lastPoints[deviceId] = lastPoint;
    notifyListeners();
  }
}
