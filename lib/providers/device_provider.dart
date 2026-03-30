import 'package:flutter/material.dart';
import 'package:my_project/local/models/device_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class DeviceProvider extends ChangeNotifier {
  final Repository repository;
  List<Device> _devices = [];

  List<Device> get devices => _devices;

  DeviceProvider({required this.repository});

  Future<void> getDevices(int objectId) async {
    _devices = await repository.getDevicesByObjectId(objectId);
    print('-------------------------------------------');
    print(_devices.length);
    notifyListeners();
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

  Future<void> deleteDevice(int id) async {
    await repository.delete('device', id);
    await getDevices(id);
  }
}
