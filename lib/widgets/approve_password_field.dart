import 'package:flutter/material.dart';

class ApprovePasswordField extends StatefulWidget {
  const ApprovePasswordField({
    required this.controller,
    super.key
  });

  final TextEditingController controller;

  @override
  State<ApprovePasswordField> createState() => _ApprovePasswordFieldState();
}

class _ApprovePasswordFieldState extends State<ApprovePasswordField> {
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
        const SizedBox(
          height: 20
        ),
        SizedBox(
          width: 250,
          height: 50,
          child: TextFormField(
            controller: widget.controller,
            obscureText: _isHidden,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Approve Password',
              icon: const Icon(Icons.lock_reset),
              suffixIcon: IconButton(
                icon:
                  _isHidden ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                onPressed: _togglePasswordVisibility,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(11))
              ),
            )
          )
        )
      ]
    );
  }
}
