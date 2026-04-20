import 'package:flutter/material.dart';
import 'package:my_project/models/object_model.dart';
import 'package:my_project/repository/object_repository.dart';
import 'package:my_project/services/mqtt_service.dart';

class ObjectProvider extends ChangeNotifier {
  final ObjectRepository repository;
  final MqttService mqttService;
  List<MyObject> _objects = [];
  List<MyObject> get objects => _objects;

  MyObject? _object;
  MyObject? get object => _object;

  ObjectProvider({
    required this.repository,
    required this.mqttService,
  });

  Future<void> getObjects(int userId) async {
    _objects = await repository.getObjectsByUserId(userId);

    for (var obj in _objects) {
      await mqttService.newSubcription('object', obj.privateName);
    }

    notifyListeners();
  }

  Future<void> getObject(int id) async {
    _object = await repository.getById(
      'object', 
      id,
      MyObject.fromMap,
    );
    notifyListeners();
  }

  Future<bool> objectExists(String privateName) async {
    final bool objectExists = await repository.modelExists(
      'object', privateName
    );
    return objectExists;
  }

  Future<void> createObject(
    String publicName,
    String privateName,
    String password,
    int userId,
    double maxTemperature,
    int defaultSpeedForDevices,
  ) async {
    final MyObject newObject = MyObject(
      publicName: publicName, 
      privateName: privateName, 
      password: password, 
      userId: userId, 
      maxTemperature: maxTemperature, 
      defaultSpeedForDevices: defaultSpeedForDevices,
    );
    await repository.insert<MyObject>(newObject, MyObject.fromMap);
    await getObjects(userId);
    await mqttService.publishMessage('creation/object/new', 'Create object $publicName');
  }

  Future<void> updateObject(
    int id,
    String publicName,
    String privateName,
    String password,
    int userId,
    double maxTemperature,
    int defaultSpeedForDevices,
  ) async {
    final MyObject updateObject = MyObject(
      id: id, 
      publicName: publicName, 
      privateName: privateName, 
      password: password, 
      userId: userId, 
      maxTemperature: maxTemperature, 
      defaultSpeedForDevices: defaultSpeedForDevices
    );
    await repository.update(updateObject, id);
    await getObjects(userId);
  }

  Future<void> deleteObject(int id, int userId) async {
    final object = await repository.getById('object', id, MyObject.fromMap);
    await repository.delete('object', id);
    await mqttService.removeSubscription('object', object!.privateName);
    await getObjects(userId);
  }

}
