import 'package:flutter/material.dart';
import 'package:my_project/local/models/user_model.dart';
import 'package:my_project/pages/profile_page.dart';
import 'package:my_project/providers/user_provider.dart';
import 'package:my_project/widgets/custom_field.dart';
import 'package:my_project/widgets/email_field.dart';
import 'package:my_project/widgets/important_button.dart';
import 'package:my_project/widgets/password_field.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final bool isRegister;
  final int? id;

  const RegisterPage({required this.isRegister, this.id, super.key});

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

  @override
  void initState() {
    super.initState();

    if (widget.isRegister == false) {
      final User currentUser = context.read<UserProvider>().user!;

      _firstNameController.text = currentUser.firstName;
      _lastNameController.text = currentUser.lastName;
      _emailController.text = currentUser.email;
    }
  }

  void _action() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final User user = context.read<UserProvider>().user!;

    widget.isRegister
        ? await userProvider.createUser(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
          )
        : await userProvider.updateUser(
            widget.id!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim() == ''
                ? user.password
                : _passwordController.text.trim(),
          );

    if (!mounted) return;

    widget.isRegister
        ? Navigator.pop(context)
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (context) => const ProfilePage()),
          );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isRegister ? 'User created' : 'User updated'),
      ),
    );
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
            widget.isRegister
                ? Navigator.pop(context)
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
          },
        ),
        title: TitlePageText(text: widget.isRegister ? 'Sign Up' : 'User'),
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
                  ImportantButton(
                    text: widget.isRegister ? 'Sign up' : 'Edit',
                    func: _action,
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
