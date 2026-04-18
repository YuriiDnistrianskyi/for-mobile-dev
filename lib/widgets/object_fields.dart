import 'package:flutter/material.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/password_field.dart';

class ObjectFields extends StatelessWidget {
  final GlobalKey formKey;
  final TextEditingController publicNameController;
  final TextEditingController? privateNameController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final TextEditingController maxTemperatureController;
  final TextEditingController defaultSpeedController;

  const ObjectFields({
    required this.formKey,
    required this.publicNameController,
    required this.maxTemperatureController,
    required this.defaultSpeedController,
    this.privateNameController,
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
            controller: publicNameController,
            keyboardType: TextInputType.text,
          ),
          if (privateNameController != null)
            CustomField(
              text: 'Private Name',
              icon: const Icon(Icons.shield),
              controller: privateNameController!,
              keyboardType: TextInputType.text,
            ),
          CustomField(
            text: 'Max Temperature',
            icon: const Icon(Icons.thermostat),
            controller: maxTemperatureController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          CustomField(
            text: 'Defaul Speed for Devices',
            icon: const Icon(Icons.speed),
            controller: defaultSpeedController,
            keyboardType: TextInputType.number,
          ),
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
