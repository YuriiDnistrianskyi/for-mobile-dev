import 'package:flutter/material.dart';
// import 'package:my_project/local/models/device_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class DeviceProvider extends ChangeNotifier {
  final Repository repository;

  DeviceProvider({
    required this.repository,
  });

}
