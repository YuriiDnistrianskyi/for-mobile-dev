import 'package:flutter/material.dart';
import 'package:my_project/local/models/temperature_graph_point_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class TemperatureGraphProvider extends ChangeNotifier {
  final Repository repository;

  TemperatureGraphProvider ({
    required this.repository,
  });

  Future<List<TemperatureGraphPoint>> getTemperatureGraph(int objectId) async {
    final List<TemperatureGraphPoint> graph = await repository.getGraph(
      'speedGraphPoint', 
      'object_id', 
      objectId, 
      TemperatureGraphPoint.fromMap
    );
    return graph;
  }

}
