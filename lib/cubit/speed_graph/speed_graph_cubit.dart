import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/speed_graph/speed_graph_state.dart';
import 'package:my_project/models/speed_graph_point_model.dart';
import 'package:my_project/repository/device_repository.dart';
import 'package:my_project/repository/graph_repository.dart';
import 'package:my_project/services/mqtt_service.dart';

class SpeedGraphCubit extends Cubit<SpeedGraphState> {
  final GraphRepository repository;
  final DeviceRepository deviceRepository;

  SpeedGraphCubit({
    required this.repository, 
    required this.deviceRepository
  }) : super(SpeedGraphState.initial());

  void listen(MqttService service) {
    service.manager.stream.listen((message) async {
      final topic = message['topic'] as String;
      final payload = message['payload'];

      if (topic.split('/')[0] == 'object') {
        final device = await deviceRepository.getDeviceByPrivateName(
          topic.split('/')[1],
        );

        if (device != null) {
          emit(state.copyWith(isLoading: true));
          await createSpeedPoint(device.id!, int.parse(payload as String));
          await getLastSpeedGraphPoint(device.id!);
          await getSpeedGraph(device.id!);
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }

  Future<void> getSpeedGraph(int deviceId) async {
    try {
      final List<SpeedGraphPoint> graph = await repository.getGraph(
        'speedGraphPoint',
        'device_id',
        deviceId,
        SpeedGraphPoint.fromMap,
      );
      emit(state.copyWith(id: deviceId, graph: graph));
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
    }
  }

  Future<void> getLastSpeedGraphPoint(int deviceId) async {
    try {
      final SpeedGraphPoint? lastPoint = await repository.getLastPoint(
        deviceId,
        'deviceId',
        'speedGraphPoint',
        SpeedGraphPoint.fromMap,
      );
      emit(state.copyWith(id: deviceId, lastPoint: lastPoint));
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
    }
  }


  Future<void> createSpeedPoint(int deviceId, int value) async {
    final point = SpeedGraphPoint(
      deviceId: deviceId, 
      time: DateTime.now().millisecondsSinceEpoch, 
      value: value
    );
    await repository.insert<SpeedGraphPoint>(point, SpeedGraphPoint.fromMap);
    await repository.trimTable('speedGraphPoint', 'deviceId', deviceId);
  }
}
