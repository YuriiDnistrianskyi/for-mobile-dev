import 'package:flutter/material.dart';
import 'package:my_project/core/mqtt_manager.dart';
import 'package:my_project/pages/root_page.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/providers/device_provider.dart';
import 'package:my_project/providers/object_provider.dart';
import 'package:my_project/providers/speed_graph_provider.dart';
import 'package:my_project/providers/temperature_graph_provider.dart';
import 'package:my_project/providers/user_provider.dart';
import 'package:my_project/providers/wifi_provider.dart';
import 'package:my_project/repository/local_repository.dart';
import 'package:my_project/services/mqtt_service.dart';
import 'package:my_project/services/notification_service.dart';
import 'package:my_project/widgets/app_background.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'cooling_system_db');

  final Repository appRepository = Repository();
  await appRepository.open(path);

  final manager = MqttManager(
    host: 'broker.hivemq.com',
    clientName: 'flutter_name',
    port: 1883,
  );
  final service = MqttService(manager: manager, repository: appRepository);
  service.init();

  runApp(MyApp(repository: appRepository, service: service,));
}

class MyApp extends StatelessWidget {
  final Repository repository;
  final MqttService service;

  const MyApp({required this.repository, required this.service, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: repository)
        ),
        ChangeNotifierProvider(
          create: (_) => 
          DeviceProvider(repository: repository, mqttService: service)
        ),
        ChangeNotifierProvider(
          create: (_) => 
          ObjectProvider(repository: repository, mqttService: service)
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = SpeedGraphProvider(repository: repository);
            provider.listen(service);
            return provider;
          }
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = TemperatureGraphProvider(repository: repository);
            provider.listen(service);
            return provider;
          }
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(repository: repository)
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = WiFiProvider();
            return provider;
          }
        ),
      ],
      child: MaterialApp(
        title: 'Cooling System',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: NotificationService.messengerKey,
        builder: (context, child) {
          return AppBackground(child: child!);
        },
        home: const RootPage()
      )
    );
  }
}
