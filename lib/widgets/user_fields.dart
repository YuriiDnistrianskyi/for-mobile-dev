import 'package:flutter/material.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/email_field.dart';
import 'package:my_project/widgets/password_field.dart';

class UserFields extends StatelessWidget {
  final GlobalKey formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;

  const UserFields({
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    this.passwordController,
    this.confirmPasswordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomField(
            text: 'Public Name',
            icon: const Icon(Icons.devices_rounded),
            controller: firstNameController,
            keyboardType: TextInputType.text,
          ),
          CustomField(
            text: 'Private Name',
            icon: const Icon(Icons.shield),
            controller: lastNameController,
            keyboardType: TextInputType.text,
          ),
          EmailField(controller: emailController),
          if (passwordController != null &&
              confirmPasswordController != null) ...[
            PasswordField(
              text: 'Password',
              icon: const Icon(Icons.lock),
              controller: passwordController!,
            ),
            PasswordField(
              text: 'Confirm Password',
              icon: const Icon(Icons.lock_reset),
              controller: confirmPasswordController!,
            ),
          ],
        ],
      )
    );
  }
}
