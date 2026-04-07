import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  final String host;
  final String clientName;
  final int port;

  late MqttServerClient _client;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  final Set<String> currentSubscribes = {};

  MqttManager({
    required this.host,
    required this.clientName,
    required this.port,
  });

  Future<void> connect() async {
    _client = MqttServerClient.withPort(host, clientName, port);
    _client.keepAlivePeriod = 60;

    _client.autoReconnect = true;
    _client.resubscribeOnAutoReconnect = true;

    await _client.connect();

    _client.updates!.listen((events) {
      for (var event in events) {
        final msg = event.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          msg.payload.message,
        );

        final topic = event.topic;

        _controller.add({
          'topic': topic,
          'payload': payload,
        });
      }
    });
  }

  Future<void> newSubscribe(String topic) async {
    if (currentSubscribes.contains(topic)) return;
    _client.subscribe(topic, MqttQos.atLeastOnce);
    currentSubscribes.add(topic);
  }

  Future<void> removeSubscribe(String topic) async {
    if (!currentSubscribes.contains(topic)) return;
    _client.unsubscribe(topic);
    currentSubscribes.remove(topic);
  }

  Future<void> publishMessage(String topic, String message) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (builder.payload == null) return;

    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void dispose() {
    _client.disconnect();
    currentSubscribes.clear();
    _controller.close();
  }
}
