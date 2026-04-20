import 'dart:async';
import 'package:my_project/core/mqtt_manager.dart';

class MqttService {
  final MqttManager manager;

  bool _isConnected = false;

  MqttService({
    required this.manager,
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
