import 'package:flutter/material.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/login_page.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/providers/wifi_provider.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _lastWiFiStatus = true;

  @override
  void initState() {
    super.initState();
    _initRootPage();
  }

  Future<void> _initRootPage() async {
    final authProvider = context.read<AuthProvider>();
    final wifiProvider = context.read<WiFiProvider>();
    await authProvider.autoLogin();

    while (!wifiProvider.isInit) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    if (!mounted) return;
    if (!wifiProvider.isConnected && authProvider.isLoggin) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No internet connection')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    // final wifiProvider = context.watch<WiFiProvider>();

    return Consumer<WiFiProvider>(
      builder: (context, wifiProveder, child) {
        if (wifiProveder.isConnected != _lastWiFiStatus) {
          _lastWiFiStatus = wifiProveder.isConnected;
          final msg = _lastWiFiStatus
              ? 'Internet is connected'
              : 'Internet is disable';

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          });
        }
        return auth.isLoggin ? child! : const LoginPage();
      },
      child: const HomePage(),
    );
  }
}
