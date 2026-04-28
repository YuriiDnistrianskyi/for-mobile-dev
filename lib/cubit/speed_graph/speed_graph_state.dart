import 'package:my_project/models/speed_graph_point_model.dart';

class SpeedGraphState {
  final Map<int, List<SpeedGraphPoint>> graphs;
  final Map<int, SpeedGraphPoint> lastPoints;
  final bool isLoading;
  final String? error;

  SpeedGraphState({
    required this.graphs,
    required this.lastPoints,
    required this.isLoading,
    this.error,
  });

  factory SpeedGraphState.initial() {
    return SpeedGraphState(
      graphs: {},
      lastPoints: {},
      isLoading: false,
    );
  }

  SpeedGraphState copyWith({
    int? id,
    List<SpeedGraphPoint>? graph,
    SpeedGraphPoint? lastPoint,
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
    return SpeedGraphState(
      graphs: graphs,
      lastPoints: lastPoints,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
