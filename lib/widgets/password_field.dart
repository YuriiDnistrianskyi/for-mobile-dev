import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.text,
    required this.icon,
    required this.controller,
    super.key,
  });

  final String text;
  final Icon icon;
  final TextEditingController controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isHidden = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: 250,
          height: 50,
          child: TextFormField(
            controller: widget.controller,
            obscureText: _isHidden,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Enter ${widget.text}',
              icon: widget.icon,
              suffixIcon: IconButton(
                icon: _isHidden
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: _togglePasswordVisibility,
              ),
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
