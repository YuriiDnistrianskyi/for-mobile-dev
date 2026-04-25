import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/tempeture_graph/temperature_graph_state.dart';
import 'package:my_project/models/temperature_graph_point_model.dart';
import 'package:my_project/repository/graph_repository.dart';
import 'package:my_project/repository/object_repository.dart';
import 'package:my_project/services/mqtt_service.dart';


class TemperatureGraphCubit extends Cubit<TemperatureGraphState> {
  final GraphRepository repository;
  final ObjectRepository objectRepository;

  TemperatureGraphCubit({
    required this.repository,
    required this.objectRepository,  
  }) : super(TemperatureGraphState.initial());

  // List<TemperatureGraphPoint> getGraph(int objectId) {
  //   return _graphs[objectId] ?? [];
  // }

  // TemperatureGraphPoint? getLastPoint(int objectId) {
  //   return _lastPoints[objectId] ??
  //       TemperatureGraphPoint(
  //         objectId: objectId,
  //         time: DateTime.now().millisecondsSinceEpoch,
  //         value: 0,
  //       );
  // }

  void listen(MqttService service) {
    service.manager.stream.listen((message) async {
      final topic = message['topic'] as String;
      final payload = message['payload'];

      if (topic.split('/')[0] == 'object') {
        final object = await objectRepository.getObjectByPrivateName(
          topic.split('/')[1],
        );

        if (object != null) {
          emit(state.copyWith(isLoading: true));
          createTemperaturePoint(
            object.id!,
            double.parse(payload as String),
          );
          getLastTemperatureGraphPoint(object.id!);
          getTemperatureGraph(object.id!);
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }

  Future<void> getTemperatureGraph(int objectId) async {
    try {
      final List<TemperatureGraphPoint> graph = await repository.getGraph(
        'temperatureGraphPoint',
        'objectId',
        objectId,
        TemperatureGraphPoint.fromMap,
      );
      emit(state.copyWith(id: objectId, graph: graph));
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
    }
  }

  Future<void> getLastTemperatureGraphPoint(int objectId) async {
    try {
      final TemperatureGraphPoint? lastPoint = await repository.getLastPoint(
        objectId,
        'objectId',
        'temperatureGraphPoint',
        TemperatureGraphPoint.fromMap,
      );
      emit(state.copyWith(id: objectId, lastPoint: lastPoint));
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
    }
  }

  Future<void> createTemperaturePoint(int objectId, double value) async {
    final TemperatureGraphPoint point = TemperatureGraphPoint(
      objectId: objectId,
      time: DateTime.now().millisecondsSinceEpoch,
      value: value,
    );
    await repository.insert<TemperatureGraphPoint>(
      point,
      TemperatureGraphPoint.fromMap,
    );
    await repository.trimTable('temperatureGraphPoint', 'objectId', objectId);
    // notifyListeners();
  }
}
