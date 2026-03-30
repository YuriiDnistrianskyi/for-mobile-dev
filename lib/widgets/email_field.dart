import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  const EmailField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  String? _validation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: 250,
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.emailAddress,
            validator: _validation,
            decoration: const InputDecoration(
              labelText: 'Enter Email',
              icon: Icon(Icons.mail),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
