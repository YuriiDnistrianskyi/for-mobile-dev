import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  const EmailField({
    required this.controller,
    super.key
  });

  final TextEditingController controller;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20
        ),
        SizedBox(
          width: 250,
          height: 50,
          child: TextField(
            controller: widget.controller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Enter Email',
              icon: Icon(Icons.mail),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11))
              ),
            )
          )
        )
      ]
    );
  }
}
