import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/user/user_cubit.dart';
import 'package:my_project/cubit/user/user_state.dart';
import 'package:my_project/models/user_model.dart';
import 'package:my_project/pages/profile_page.dart';
import 'package:my_project/providers/wifi_provider.dart';
import 'package:my_project/widgets/form_layer.dart';
import 'package:my_project/widgets/user_fields.dart';

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
  final _formKey = GlobalKey<FormState>();

  void _action() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = context.read<UserCubit>();
      final wifiStatus = context.read<WiFiProvider>().isConnected;

      if (!wifiStatus) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No internet connection')));
        return;
      }

      final bool userExists = await userProvider.userExists(
        _emailController.text.trim(),
      );
      if (!mounted) return;

      if (_passwordController.text.trim() !=
          _confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }

      if (widget.isRegister) {
        if (userExists) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('User already exists')));
          return;
        }
        await userProvider.createUser(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        if (!mounted) return;
        final User user = context.read<UserCubit>().state.user!;
        await userProvider.updateUser(
          widget.id!,
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          user.email,
          user.password ?? '123456789',
        );
      }

      if (!mounted) return;
      widget.isRegister
          ? Navigator.pop(context)
          : Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (context) => const ProfilePage(),
              ),
            );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isRegister ? 'User created' : 'User updated'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<UserCubit>(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (widget.isRegister == false) {
            final user = state.user!;
            _firstNameController.text = user.firstName;
            _lastNameController.text = user.lastName;
            _emailController.text = user.email;
          }
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return FormLayer(
            title: widget.isRegister ? 'Register' : 'Edit Profile',
            backAction: () {
              widget.isRegister
                  ? Navigator.pop(context)
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
            },
            fields: UserFields(
              formKey: _formKey,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              emailController: _emailController,
              passwordController: widget.isRegister
                  ? _passwordController
                  : null,
              confirmPasswordController: widget.isRegister
                  ? _confirmPasswordController
                  : null,
            ),
            textButton: widget.isRegister ? 'Register' : 'Edit',
            pressAction: _action,
          );
        },
      ),
    );
  }
}
