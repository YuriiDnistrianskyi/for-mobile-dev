// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/object/object_state.dart';
import 'package:my_project/models/object_model.dart';
import 'package:my_project/repository/object_repository.dart';
import 'package:my_project/services/mqtt_service.dart';


class ObjectCubit extends Cubit<ObjectState> {
  final ObjectRepository repository;
  final MqttService mqttService;

  ObjectCubit({
    required this.repository,
    required this.mqttService,
  }) : super(ObjectState.initial());

  Future<void> getObjects(int userId) async {
    try {
      emit(state.copyWith(isLoading: true));


      final objects = await repository.getObjectsByUserId(userId);

      for (var obj in objects) {
        await mqttService.newSubcription('object', obj.privateName);
      }

      emit(state.copyWith(isLoading: false, objects: objects));
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
    }
  }

  Future<void> getObject(int id) async {
    try {
      emit(state.copyWith(isLoading: true));
        final object = await repository.getById(
        'object', 
        id,
        MyObject.fromMap,
      );
      emit(state.copyWith(isLoading: false, object: object));
    } catch (ex) {
      emit(state.copyWith(isLoading: false, error: ex.toString()));
    }
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
    await mqttService.publishMessage('creation/object/new', 'Create object $publicName');
    await getObjects(userId);
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
