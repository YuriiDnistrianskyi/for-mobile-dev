import 'package:flutter/material.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/providers/object_provider.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/password_field.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';

class CreateObjectPage extends StatefulWidget {
  final String type;
  final int? id;

  const CreateObjectPage({
    required this.type, 
    this.id,
    super.key
  });

  @override
  State<CreateObjectPage> createState() => _CreateObjectPageState();
}

class _CreateObjectPageState extends State<CreateObjectPage> {
  final TextEditingController _publicNameController = TextEditingController();
  final TextEditingController _privateNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _maxTemperatureComtroller =
      TextEditingController();
  final TextEditingController _defaulSpeedController = TextEditingController();

  void _createObject() async {
    final objectProvider = context.read<ObjectProvider>();
    final authProvider = context.read<AuthProvider>();

    await objectProvider.createObject(
      _publicNameController.text, 
      _privateNameController.text, 
      _passwordController.text, 
      authProvider.userId, 
      double.parse(_maxTemperatureComtroller.text.trim()), 
      int.parse(_defaulSpeedController.text),
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  void _updateObject() async {
    final objectProvider = context.read<ObjectProvider>();
    final authProvider = context.read<AuthProvider>();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: TitlePageText(text: '${widget.type} Object'),
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
                  CustomField(
                    text: 'Max Temperature',
                    icon: const Icon(Icons.thermostat),
                    controller: _maxTemperatureComtroller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true
                    ),
                  ),
                  CustomField(
                    text: 'Defaul Speed for Devices',
                    icon: const Icon(Icons.speed),
                    controller: _defaulSpeedController,
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
                  ImportantButton(
                    text: 'Create object', 
                    func: widget.type == 'Create' ?
                      _createObject :
                      _updateObject
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
