// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/core/api/api_client.dart';
import 'package:my_project/core/api/api_service.dart';

import 'package:my_project/core/mqtt_manager.dart';
import 'package:my_project/core/token_store.dart';

import 'package:my_project/main.dart';
import 'package:my_project/repository/general_repository.dart';
import 'package:my_project/services/mqtt_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cooling_system_db');

    final db = await GeneralRepository.open(path);

    final manager = MqttManager(
      host: 'broker.hivemq.com',
      clientName: 'flutter_client',
      port: 1883,
    );
    final service = MqttService(manager: manager);
    await service.init();

    final TokenStore tokenStore = TokenStore();
    final ApiClient apiClient = ApiClient(tokenStore: tokenStore);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      db: db, 
      service: service, 
      apiClient: apiClient,
      apiService: ApiService(dio: apiClient.dio), 
      tokenStore: tokenStore
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
