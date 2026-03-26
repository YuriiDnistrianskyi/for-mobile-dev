import 'package:flutter/material.dart';
// import 'package:my_project/local/models/object_model.dart';
import 'package:my_project/local/repository/local_repository.dart';

class ObjectProvider extends ChangeNotifier {
  final Repository repository;

  ObjectProvider({
    required this.repository,
  });

}
