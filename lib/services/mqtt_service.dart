import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_project/core/mqtt_manager.dart';
// import 'package:my_project/models/speed_graph_point_model.dart';
// import 'package:my_project/models/temperature_graph_point_model.dart';
import 'package:my_project/repository/local_repository.dart';

class MqttService extends ChangeNotifier {
  final MqttManager manager;
  final Repository repository;

  MqttService({
    required this.manager,
    required this.repository,
  });

  Future<void> init() async {
    await manager.connect();
  }

  Future<void> newSubcription(String type, String privateName) async {
    final end = type == 'object'
        ? 'temperature'
        : 'power';
    await manager.newSubscribe('$type/$privateName/$end');
  }

  Future<void> removeSubscription(String type, String privateName) async {
    final end = type == 'object'
        ? 'temperature'
        : 'power';
    await manager.removeSubscribe('$type/$privateName/$end');
  }

  Future<void> publishMessage(String topic, String message) async {
    await manager.publishMessage(topic, message);
  }

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }
}
