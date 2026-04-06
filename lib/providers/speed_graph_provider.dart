import 'package:flutter/material.dart';
import 'package:my_project/models/speed_graph_point_model.dart';
import 'package:my_project/repository/local_repository.dart';
import 'package:my_project/services/mqtt_service.dart';

class SpeedGraphProvider extends ChangeNotifier {
  final Repository repository;
  final Map<int, List<SpeedGraphPoint>> _graphs = {};
  final Map<int, SpeedGraphPoint?> _lastPoints = {};

  SpeedGraphProvider({required this.repository});

  void listen(MqttService service) {
    service.manager.stream.listen((message) async {
      final topic = message['topic'] as String;
      final payload = message['payload'];

      if (topic.split('/')[0] == 'object') {
        final device = await repository.getDeviceByPrivateName(
          topic.split('/')[1],
        );

        if (device != null) {
          await createSpeedPoint(device.id!, int.parse(payload as String));
          await getLastSpeedGraphPoint(device.id!);
          await getSpeedGraph(device.id!);
        }
      }
    });
  }

  List<SpeedGraphPoint> getGraph(int deviceId) {
    return _graphs[deviceId] ?? [];
  }

  SpeedGraphPoint? getLastPoint(int deviceId) {
    return _lastPoints[deviceId];
  }

  Future<void> getSpeedGraph(int deviceId) async {
    final List<SpeedGraphPoint> graph = await repository.getGraph(
      'speedGraphPoint',
      'device_id',
      deviceId,
      SpeedGraphPoint.fromMap,
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


  Future<void> createSpeedPoint(int deviceId, int value) async {
    final point = SpeedGraphPoint(
      deviceId: deviceId, 
      time: DateTime.now().millisecondsSinceEpoch, 
      value: value
    );
    await repository.insert(point);
    await repository.trimTable('speedGraphPoint', 'deviceId', deviceId);
    notifyListeners();
  }
}
