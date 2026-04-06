import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_project/core/mqtt_manager.dart';

class MqttService extends ChangeNotifier {
  final MqttManager manager;

  StreamSubscription<dynamic>? _subscription;

  MqttService({
    required this.manager,
  });

  Future<void> init() async {
    await manager.connect();

    _subscription = manager.stream.listen((manager) {
      final topic = manager['topic'];
      final payload = manager['payload'];

      print(topic);
      print(payload);

      notifyListeners(); //
    });
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

  @override
  void dispose() {
    _subscription!.cancel();
    manager.dispose();
    super.dispose();
  }
}
