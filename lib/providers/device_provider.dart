import 'package:flutter/material.dart';
import 'package:my_project/local/models/device_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class DeviceProvider extends ChangeNotifier {
  final Repository repository;

  DeviceProvider({
    required this.repository,
  });

  Future<List<Device>> getDevices(int objectId) async {
    final List<Device> devices = await repository.getDevicesByObjectIs(objectId);
    return devices;
  }

  Future<void> createDevice(
    String publicName,
    String privatName,
    String password,
    int objectId,
  ) async {
    final Device newDevice = Device(
      id: 1,  //
      publicName: publicName, 
      privateName: privatName, 
      password: password, 
      objectId: objectId
    );
    await repository.insert(newDevice);
  }

  Future<void> updateDevice(
    int id,
    String publicName,
    String privatName,
    String password,
    int objectId,
  ) async {
    final Device newDevice = Device(
      id: id,  //
      publicName: publicName, 
      privateName: privatName, 
      password: password, 
      objectId: objectId
    );
    await repository.update(newDevice, id);
  }

  Future<void> deleteDevice(int id) async {
    await repository.delete('device', id);
  }
}
