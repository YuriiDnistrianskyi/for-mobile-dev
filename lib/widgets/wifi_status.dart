import 'package:flutter/material.dart';
import 'package:my_project/providers/wifi_provider.dart';
import 'package:provider/provider.dart';

class WiFiStatus extends StatelessWidget {
  const WiFiStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final wifiStatus = context.watch<WiFiProvider>().isConnected;

    return !wifiStatus
        ? const SizedBox(
            child: Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Text(
                'No internet connection',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : const SizedBox(height: 20);
  }
}
