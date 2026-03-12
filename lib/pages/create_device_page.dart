import 'package:flutter/material.dart';
import 'package:my_project/widgets/confirm_password_field.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/password_field.dart';
import 'package:my_project/widgets/title_page_text.dart';

class CreateDevicePage extends StatefulWidget {
  const CreateDevicePage({super.key});

  @override
  State<CreateDevicePage> createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  final TextEditingController _nameComtroller = TextEditingController();
  final TextEditingController _passwordComtroller = TextEditingController();
  // ignore: lines_longer_than_80_chars
  final TextEditingController _approvePasswordComtroller = TextEditingController();
  // ignore: lines_longer_than_80_chars

  void _createDevice() {
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
          icon: const Icon(Icons.arrow_back, color: Colors.white)
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomField(
                    text: 'Name', 
                    icon: const Icon(Icons.devices_rounded), 
                    controller: _nameComtroller, 
                    keyboardType: TextInputType.text
                  ),
                  PasswordField(
                    controller: _passwordComtroller
                  ),
                  ConfirmPasswordField(
                    controller: _approvePasswordComtroller
                  ),
                  const SizedBox(height: 20),
                  ImportantButton(
                    text: 'Create device', 
                    func: _createDevice,
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
} 
