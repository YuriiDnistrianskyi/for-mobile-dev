import 'package:flutter/material.dart';
import 'package:my_project/pages/login_page.dart';
import 'package:my_project/widgets/app_background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 2, 30, 47)),
      ),
      builder: (context, child) {
        return AppBackground(
          child: child!
        );
      },
      home: const LoginPage(),
    );
  }
}
