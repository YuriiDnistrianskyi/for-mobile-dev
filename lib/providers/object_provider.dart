import 'package:flutter/material.dart';
import 'package:my_project/local/models/object_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class ObjectProvider extends ChangeNotifier {
  final Repository repository;

  ObjectProvider({
    required this.repository,
  });

  Future<MyObject?> getObject(int id) async {
    final MyObject? object = await repository.getById(
      'object', id, 
      MyObject.fromMap,
    );
    return object;
  }

  Future<List<MyObject>> getObjects(int userId) async {
    final List<MyObject> objects = await repository.getObjectsByUserId(userId);
    return objects;
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
      id: 1, 
      publicName: publicName, 
      privateName: privateName, 
      password: password, 
      userId: userId, 
      maxTemperature: maxTemperature, 
      defaultSpeedForDevices: defaultSpeedForDevices,
    );
    await repository.insert(newObject);
  }

}
