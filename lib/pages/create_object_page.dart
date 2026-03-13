import 'package:flutter/material.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/password_field.dart';
import 'package:my_project/widgets/title_page_text.dart';

class CreateObjectPage extends StatefulWidget {
  const CreateObjectPage({super.key});

  @override
  State<CreateObjectPage> createState() => _CreateObjectPageState();
}

class _CreateObjectPageState extends State<CreateObjectPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _maxTemperatureComtroller =
      TextEditingController();

  void _createObject() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const TitlePageText(text: 'Create Object'),
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
                    text: 'Name',
                    icon: const Icon(Icons.devices_rounded),
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                  ),
                  CustomField(
                    text: 'Max Temperature',
                    icon: const Icon(Icons.thermostat),
                    controller: _maxTemperatureComtroller,
                    keyboardType: TextInputType.number,
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
                  ImportantButton(text: 'Create object', func: _createObject),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
