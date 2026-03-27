import 'package:flutter/material.dart';
import 'package:my_project/providers/user_provider.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/email_field.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/password_field.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _signUp() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.createUser(
      _firstNameController.text,
      _lastNameController.text,
      _emailController.text, 
      _passwordController.text,
    );

    if (!mounted) return;

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
        title: const TitlePageText(text: 'Sign Up'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 450,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomField(
                    text: 'First Name',
                    icon: const Icon(Icons.account_circle),
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                  ),
                  CustomField(
                    text: 'Last Name',
                    icon: const Icon(Icons.account_circle),
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                  ),
                  EmailField(controller: _emailController),
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
                  ImportantButton(text: 'Sign up', func: _signUp),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
