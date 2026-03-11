import 'package:flutter/material.dart';
import 'package:my_project/widgets/approve_password_field.dart';
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
  final TextEditingController _nameComtroller = TextEditingController();
  final TextEditingController _passwordComtroller = TextEditingController();
  // ignore: lines_longer_than_80_chars
  final TextEditingController _approvePasswordComtroller = TextEditingController();
  // ignore: lines_longer_than_80_chars
  final TextEditingController _maxTemperatureComtroller = TextEditingController();

  void _createObject() {

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
          icon: const Icon(Icons.arrow_back, color: Colors.white)
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 350,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomField(
                  text: 'Name', 
                  icon: const Icon(Icons.devices_rounded), 
                  controller: _nameComtroller, 
                  keyboardType: TextInputType.text
                ),
                CustomField(
                  text: 'Max Temperature', 
                  icon: const Icon(Icons.thermostat), 
                  controller: _maxTemperatureComtroller, 
                  keyboardType: TextInputType.number),
                PasswordField(
                  controller: _passwordComtroller
                ),
                ApprovePasswordField(
                  controller: _approvePasswordComtroller
                ),
                const SizedBox(height: 20),
                ImportantButton(
                  text: 'Create object', 
                  func: _createObject,
                )
              ]
            )
          )
        )
      )
    );
  }
} 
