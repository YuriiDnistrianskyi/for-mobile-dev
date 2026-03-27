import 'package:flutter/material.dart';
import 'package:my_project/providers/device_provider.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/password_field.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';

class CreateDevicePage extends StatefulWidget {
  final int objectId;

  const CreateDevicePage({required this.objectId, super.key});

  @override
  State<CreateDevicePage> createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  final TextEditingController _publicNameController = TextEditingController();
  final TextEditingController _privateNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = 
      TextEditingController();

  void _createDevice() async {
    final deviceProvider = context.read<DeviceProvider>();

    await deviceProvider.createDevice(
      _publicNameController.text.trim(), 
      _privateNameController.text.trim(), 
      _passwordController.text.trim(), 
      widget.objectId,
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const TitlePageText(text: 'Create device'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomField(
                    text: 'Public Name',
                    icon: const Icon(Icons.devices_rounded),
                    controller: _publicNameController,
                    keyboardType: TextInputType.text,
                  ),
                  CustomField(
                    text: 'Private Name', 
                    icon: const Icon(Icons.shield), 
                    controller: _privateNameController, 
                    keyboardType: TextInputType.text,
                  ),
                  PasswordField(
                    text: 'Password',
                    icon: const Icon(Icons.lock),
                    controller: _passwordController,
                  ),
                  PasswordField(
                    text: 'Confirm Password',
                    icon: const Icon(Icons.lock_reset),
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 20),
                  ImportantButton(text: 'Create device', func: _createDevice),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
