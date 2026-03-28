import 'package:flutter/material.dart';
import 'package:my_project/local/models/object_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class ObjectProvider extends ChangeNotifier {
  final Repository repository;
  List<MyObject> _objects = [];

  List<MyObject> get objects => _objects;

  ObjectProvider({
    required this.repository,
  });

  Future<MyObject> getObject(int id) async {
    final MyObject? object = await repository.getById(
      'object', id,
      MyObject.fromMap,
    );
    return object!;
  }

  Future<void> getObjects(int userId) async {
    _objects = await repository.getObjectsByUserId(userId);
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
    await repository.insert(newObject);
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
  }

  Future<void> deleteObject(int id) async {
    await repository.delete('object', id);
  }

}
