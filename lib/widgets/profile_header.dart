import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.firstName,
    required this.lastName,
    required this.email,
    super.key,
  });

  final String firstName;
  final String lastName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 93, 174, 129),
            radius: 50,
            child: Icon(Icons.account_circle),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05),
          Expanded(
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Color.fromARGB(96, 82, 95, 87),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(email, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
