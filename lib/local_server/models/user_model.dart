import 'package:my_project/local_server/models/i_model.dart';

class User extends IModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'fisrtName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  
    return data;
  }
}
