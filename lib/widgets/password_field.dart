import 'package:flutter/material.dart';
import 'package:my_project/core/banned_passwords.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    required this.text,
    required this.icon,
    required this.controller,
    super.key,
  });

  final String text;
  final Icon icon;
  final TextEditingController controller;

  // bool _isHidden = true;

  // void _togglePasswordVisibility() {
  //   setState(() {
  //     _isHidden = !_isHidden;
  //   });
  // }

  String? _validation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Passord is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (bannedPasswords.contains(value.toLowerCase())) {
      return 'Password is banned';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isHidden = ValueNotifier<bool>(true);

    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: 250,
          child: ValueListenableBuilder<bool>(
            valueListenable: isHidden,
            builder: (context, value, _) {
              return TextFormField(
                controller: controller,
                obscureText: value,
                keyboardType: TextInputType.visiblePassword,
                validator: _validation,
                decoration: InputDecoration(
                  labelText: 'Enter $text',
                  icon: icon,
                  suffixIcon: IconButton(
                    icon: value
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () => isHidden.value = !isHidden.value,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
