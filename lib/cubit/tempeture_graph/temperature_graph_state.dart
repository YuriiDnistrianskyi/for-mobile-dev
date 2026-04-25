import 'package:my_project/models/temperature_graph_point_model.dart';

class TemperatureGraphState {
  final Map<int, List<TemperatureGraphPoint>> graphs;
  final Map<int, TemperatureGraphPoint> lastPoints;
  final bool isLoading;
  final String? error;

  TemperatureGraphState({
    required this.graphs,
    required this.lastPoints,
    required this.isLoading,
    this.error,
  });

  factory TemperatureGraphState.initial() {
    return TemperatureGraphState(
      graphs: {},
      lastPoints: {},
      isLoading: false,
    );
  }

  TemperatureGraphState copyWith({
    int? id,
    List<TemperatureGraphPoint>? graph,
    TemperatureGraphPoint? lastPoint,
    bool? isLoading,
    String? error,
  }) {
    if (id != null) {
      if (graph != null) {
        graphs[id] = graph;
      }
      if (lastPoint != null) {
        lastPoints[id] = lastPoint;
      }
    }
    return TemperatureGraphState(
      graphs: graphs,
      lastPoints: lastPoints,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
