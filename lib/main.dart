import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/core/api/api_client.dart';
import 'package:my_project/core/api/api_service.dart';
import 'package:my_project/core/mqtt_manager.dart';
import 'package:my_project/core/token_store.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/device/device_cubit.dart';
import 'package:my_project/cubit/object/object_cubit.dart';
import 'package:my_project/cubit/speed_graph/speed_graph_cubit.dart';
import 'package:my_project/cubit/tempeture_graph/temperature_graph_cubit.dart';
import 'package:my_project/cubit/user/user_cubit.dart';
import 'package:my_project/pages/root_page.dart';
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
          create: (context) {
            final cubit = AuthCubit(
              repository: UserRepository(db: db, api: apiService), 
              tokenStore: tokenStore, 
              apiClient: apiClient
            );
            cubit.listen();
            cubit.autoLogin();
            return cubit;
          }
        ),
        BlocProvider(
          create: (context) => ObjectCubit(
            repository: context.read<ObjectRepository>(),
            mqttService: service
          )
        ),
        BlocProvider(
          create: (context) => DeviceCubit(
            repository: context.read<DeviceRepository>(),
            mqttService: service,
          )
        ),
        BlocProvider(
          create: (context) => UserCubit(
            repository: UserRepository(db: db, api: apiService)
          )
        ),
        BlocProvider(
          create: (context) {
            final cubit = SpeedGraphCubit(
              repository: GraphRepository(db: db, api: apiService), 
              deviceRepository: context.read<DeviceRepository>(),
            );
            cubit.listen(service);
            return cubit;
          }
        ),
        BlocProvider(
          create: (context) {
            final cubit = TemperatureGraphCubit(
              repository: GraphRepository(db: db, api: apiService), 
              objectRepository: context.read<ObjectRepository>(),
            );
            cubit.listen(service);
            return cubit;
          }
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = WiFiProvider();
            provider.init();
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
