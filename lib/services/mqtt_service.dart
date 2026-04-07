import 'dart:async';
import 'package:my_project/core/mqtt_manager.dart';
import 'package:my_project/repository/local_repository.dart';

class MqttService {
  final MqttManager manager;
  final Repository repository;

  bool _isConnected = false;

  MqttService({
    required this.manager,
    required this.repository,
  });

  Future<void> init() async {
    while (true) {
      try {
        await manager.connect();
        _isConnected = true;
        break;
      } catch (ex) {
        _isConnected = false;
        await Future<void>.delayed(const Duration(seconds: 5));
      }
    }
  }

  Future<void> newSubcription(String type, String privateName) async {
    if (!_isConnected) return;
    final end = type == 'object'
        ? 'temperature'
        : 'power';
    await manager.newSubscribe('$type/$privateName/$end');
  }

  Future<void> removeSubscription(String type, String privateName) async {
    if (!_isConnected) return;
    final end = type == 'object'
        ? 'temperature'
        : 'power';
    await manager.removeSubscribe('$type/$privateName/$end');
  }

  Future<void> publishMessage(String topic, String message) async {
    if (!_isConnected) return;
    await manager.publishMessage(topic, message);
  }
}
