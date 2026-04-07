import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_project/services/notification_service.dart';

class WiFiProvider extends ChangeNotifier {
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  bool _isInit = false;
  bool get isInit => _isInit;

  StreamSubscription<InternetStatus>? _subscription;
  
  WiFiProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      _isConnected = await InternetConnection().hasInternetAccess;
    } catch (e) {
      _isConnected = false;
    }
    _isInit = true;
    notifyListeners();

    _subscription = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      bool newConnection = false;
      if (status == InternetStatus.connected) {
        newConnection = true;
      } else {
        newConnection = false;
      }
      if (newConnection != _isConnected) {
        _isConnected = newConnection;
        NotificationService.show(
          _isConnected ? 'Internet connected': 'Internet desable'
        );
        notifyListeners();
      }
    }
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
