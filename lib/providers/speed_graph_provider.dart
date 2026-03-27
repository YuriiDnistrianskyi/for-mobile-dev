import 'package:flutter/material.dart';
import 'package:my_project/local/models/speed_graph_point_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class SpeedGraphProvider extends ChangeNotifier {
  final Repository repository;

  SpeedGraphProvider ({
    required this.repository,
  });

  Future<List<SpeedGraphPoint>> getSpeedGraph(int deviceId) async {
    final List<SpeedGraphPoint> graph = await repository.getGraph(
      'speedGraphPoint', 
      'device_id', 
      deviceId, 
      SpeedGraphPoint.fromMap
    );
    return graph;
  }

}
