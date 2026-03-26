import 'package:flutter/material.dart';
// import 'package:my_project/local/models/user_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class UserProvider extends ChangeNotifier {
  final Repository repository;

  UserProvider ({
    required this.repository,
  });

}
