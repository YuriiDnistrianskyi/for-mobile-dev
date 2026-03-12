import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  const CustomField({
    required this.text,
    required this.icon,
    required this.controller,
    required this.keyboardType,
    super.key,
  });

  final String text;
  final Icon icon;
  final TextInputType keyboardType;
  final TextEditingController controller;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: 250,
          height: 50,
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              labelText: 'Enter ${widget.text}',
              icon: widget.icon,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
