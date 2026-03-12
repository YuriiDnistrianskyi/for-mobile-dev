import 'package:flutter/material.dart';
import 'package:my_project/widgets/confirm_password_field.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/email_field.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/password_field.dart';
import 'package:my_project/widgets/title_page_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // ignore: lines_longer_than_80_chars
  final TextEditingController _aprovePasswordController = TextEditingController();

  void _signUp() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const TitlePageText(text: 'Sign Up')
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 350,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: SingleChildScrollView(
            child: 
            Column(
              children: [
                CustomField(
                  text: 'Name',
                  icon: const Icon(Icons.account_circle),
                  controller: _nameController,
                  keyboardType: TextInputType.name
                ),
                EmailField(controller: _emailController),
                PasswordField(controller: _passwordController),
                ConfirmPasswordField(controller: _aprovePasswordController),
                const SizedBox(height: 20),
                ImportantButton(text: 'Sign up', func: _signUp)
              ]
            )
         )
        )
      )
    );
  }
}
