import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class WiFiProvider extends ChangeNotifier {
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  StreamSubscription<InternetStatus>? _subscription;
  
  WiFiProvider() {
    _init();
  }

  void _init() {
    _subscription = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      if (status == InternetStatus.connected) {
        _isConnected = true;
      } else {
        _isConnected = false;
      }
      notifyListeners();
    }
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
