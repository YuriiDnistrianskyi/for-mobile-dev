import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/core/api/api_client.dart';
import 'package:my_project/core/api/api_service.dart';
import 'package:my_project/core/mqtt_manager.dart';
import 'package:my_project/core/token_store.dart';
import 'package:my_project/cubit/object/object_cubit.dart';
import 'package:my_project/pages/root_page.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/providers/device_provider.dart';
// import 'package:my_project/providers/object_provider.dart';
import 'package:my_project/providers/speed_graph_provider.dart';
import 'package:my_project/providers/temperature_graph_provider.dart';
import 'package:my_project/providers/user_provider.dart';
import 'package:my_project/providers/wifi_provider.dart';
import 'package:my_project/repository/device_repository.dart';
import 'package:my_project/repository/general_repository.dart';
import 'package:my_project/repository/graph_repository.dart';
import 'package:my_project/repository/object_repository.dart';
import 'package:my_project/repository/user_repository.dart';
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

  final db = await GeneralRepository.open(path);

  final manager = MqttManager(
    host: 'broker.hivemq.com',
    clientName: 'flutter_name',
    port: 1883,
  );
  final service = MqttService(manager: manager);
  service.init();

  final TokenStore tokenStore = TokenStore();
  final ApiClient apiClient = ApiClient(tokenStore: tokenStore);

  runApp(
    MyApp(
      db: db, 
      service: service, 
      apiClient: apiClient,
      apiService: ApiService(dio: apiClient.dio), 
      tokenStore: tokenStore
    )
  );
}

class MyApp extends StatelessWidget {
  final Database db;
  final MqttService service;
  final ApiClient apiClient;
  final ApiService apiService;
  final TokenStore tokenStore;

  const MyApp({
    required this.db,
    required this.service,
    required this.apiClient,
    required this.apiService,
    required this.tokenStore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DeviceRepository>(
          create: (_) => DeviceRepository(db: db, api: apiService),
        ),
        Provider<ObjectRepository>(
          create: (_) => ObjectRepository(db: db, api: apiService),
        ),
        Provider<MqttService>(
          create: (context) => service,
        ),
        BlocProvider(
          create: (context) => ObjectCubit(
            repository: context.read<ObjectRepository>(),
            mqttService: service
          )
        ),

        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            repository: UserRepository(db: db, api: apiService),
            tokenStore: tokenStore,
            apiClient: apiClient
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DeviceProvider(
            repository: context.read<DeviceRepository>(),
            mqttService: service,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final provider = SpeedGraphProvider(
              repository: GraphRepository(db: db, api: apiService),
              deviceRepository: context.read<DeviceRepository>(),
            );
            provider.listen(service);
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final provider = TemperatureGraphProvider(
              repository: GraphRepository(db: db, api: apiService),
              objectRepository: context.read<ObjectRepository>(),
            );
            provider.listen(service);
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            repository: UserRepository(db: db, api: apiService),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = WiFiProvider();
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Cooling System',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: NotificationService.messengerKey,
        builder: (context, child) {
          return AppBackground(child: child!);
        },
        home: const RootPage(),
      ),
    );
  }
}
