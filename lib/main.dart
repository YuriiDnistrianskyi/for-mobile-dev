import 'package:flutter/material.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/login_page.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/widgets/app_background.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Cooling System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 3, 79, 49)
          )
        ),
        builder: (context, child) {
          return AppBackground(child: child!);
        },
        home: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            return auth.isLoggin ?
              const HomePage() :
              const LoginPage();
          }
        )
      )
    );
  }
}
