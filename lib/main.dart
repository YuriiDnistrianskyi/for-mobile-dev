import 'package:flutter/material.dart';
import 'package:my_project/local/repository/local_repository.dart';
import 'package:my_project/pages/root_page.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/providers/device_provider.dart';
import 'package:my_project/providers/object_provider.dart';
import 'package:my_project/providers/speed_graph_provider.dart';
import 'package:my_project/providers/temperature_graph_provider.dart';
import 'package:my_project/providers/user_provider.dart';
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

  runApp(MyApp(repository: appRepository));
}

class MyApp extends StatelessWidget {
  final Repository repository;

  const MyApp({required this.repository, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(
          repository: repository
        )),
        ChangeNotifierProvider(
          create: (_) => DeviceProvider(repository: repository)
        ),
        ChangeNotifierProvider(
          create: (_) => ObjectProvider(repository: repository)
        ),
        ChangeNotifierProvider(
          create: (_) => SpeedGraphProvider(repository: repository)
        ),
        ChangeNotifierProvider(
          create: (_) => TemperatureGraphProvider(repository: repository)
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(repository: repository)
        ),
      ],
      child: MaterialApp(
        title: 'Cooling System',
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return AppBackground(child: child!);
        },
        home: const RootPage()
      )
    );
  }
}
