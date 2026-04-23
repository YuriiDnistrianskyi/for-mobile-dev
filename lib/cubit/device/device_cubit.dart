// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/device/device_state.dart';
import 'package:my_project/models/device_model.dart';
import 'package:my_project/repository/device_repository.dart';
import 'package:my_project/services/mqtt_service.dart';

class DeviceCubit extends Cubit<DeviceState> {
  final DeviceRepository repository;
  final MqttService mqttService;

  DeviceCubit({
    required this.repository,
    required this.mqttService,
  }) : super(DeviceState.initial());

  Future<void> getDevices(int objectId) async {
    try {
      emit(state.copyWith(isLoading: true));
      final devices = await repository.getDevicesByObjectId(objectId);
      emit(state.copyWith(devices: devices, isLoading: false));
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
    }
  }

  Future<void> getDevice(int deviceId) async {
    try {
      emit (state.copyWith(isLoading: true));
      final device = await repository.getById(
        'device', 
        deviceId, 
        Device.fromMap
      );
      emit(state.copyWith( isLoading: false, device: device));
    } catch (ex) {
      emit(state.copyWith( isLoading: false, error: ex.toString()));
    }
  }

  Future<bool> deviceExists(String privateName) async {
    final bool deviceExists = await repository.modelExists(
      'device', privateName
    );
    return deviceExists;
  }

  Future<void> createDevice(
    String publicName,
    String privatName,
    String password,
    int objectId,
  ) async {
    final Device newDevice = Device(
      publicName: publicName,
      privateName: privatName,
      password: password,
      objectId: objectId,
    );
    await repository.insert<Device>(newDevice, Device.fromMap);
    await getDevices(objectId);
  }

  Future<void> updateDevice(
    int id,
    String publicName,
    String privatName,
    String password,
    int objectId,
  ) async {
    final Device newDevice = Device(
      id: id, //
      publicName: publicName,
      privateName: privatName,
      password: password,
      objectId: objectId,
    );
    await repository.update(newDevice, id);
    await getDevices(objectId);
  }

  Future<void> deleteDevice(int id, int objectId) async {
    await repository.delete('device', id);
    await getDevices(objectId);
  }
}
