import 'package:flutter/material.dart';
import 'package:my_project/models/device_model.dart';
import 'package:my_project/repository/local_repository.dart';
import 'package:my_project/services/mqtt_service.dart';

class DeviceProvider extends ChangeNotifier {
  final Repository repository;
  final MqttService mqttService;
  List<Device> _devices = [];
  List<Device> get devices => _devices;
  
  Device? _device;
  Device? get device => _device;

  DeviceProvider({
    required this.repository,
    required this.mqttService,
  });

  Future<void> getDevices(int objectId) async {
    _devices = await repository.getDevicesByObjectId(objectId);
    notifyListeners();
  }

  Future<void> getDevice(int deviceId) async {
    _device = await repository
      .getById('device', deviceId, Device.fromMap);
    notifyListeners();
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
    await repository.insert(newDevice);
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
