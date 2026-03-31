import 'package:flutter/material.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/login_page.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return auth.isLoggin ? const HomePage() : const LoginPage();
  }
}
