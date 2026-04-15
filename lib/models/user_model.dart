import 'package:my_project/models/i_model.dart';

class User extends IModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    this.id,
  });

  @override
  factory User.fromMap(Map<String, dynamic> map) => User(
    id: int.parse(map['id'].toString()),
    firstName: map['firstName'] as String,
    lastName: map['lastName'] as String,
    email: map['email'] as String,
  );

  @override
  String getTableName() => 'user';

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };

    return data;
  }
}
