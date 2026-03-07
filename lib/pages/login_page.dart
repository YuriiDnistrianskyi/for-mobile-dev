import 'package:flutter/material.dart';
import 'package:my_project/pages/register_page.dart';
import 'package:my_project/widgets/email_field.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.setLogging, super.key});

  final void Function(bool) setLogging;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    widget.setLogging(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            )
          )
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              width: 300,
              height: 220,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  EmailField(
                    controller: _emailController,
                  ),
                  PasswordField(
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  ImportantButton(
                    text: 'Login',
                    func: _login,
                  )
                ]
              )
            ),
            TextButton(
              child: const Text(
                'Dont have an account? Sign up',
                style: TextStyle(
                  color: Colors.white
                )
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const RegisterPage()
                  )
                );
              }
            )
          ]
        )
      ),
    );
  }
}
