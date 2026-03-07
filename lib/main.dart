import 'package:flutter/material.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/login_page.dart';
import 'package:my_project/widgets/app_background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLogging = false;

  void setLogging(bool value) {
    setState(() {
      _isLogging = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // ignore: lines_longer_than_80_chars
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 3, 79, 49)),
      ),
      builder: (context, child) {
        return AppBackground(
          child: child!
        );
      },
      home: _isLogging ? const HomePage() : LoginPage(setLogging: setLogging)
    );
  }
}
