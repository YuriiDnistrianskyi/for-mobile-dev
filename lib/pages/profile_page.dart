import 'package:flutter/material.dart';
import 'package:my_project/models/user_model.dart';
import 'package:my_project/pages/login_page.dart';
import 'package:my_project/pages/register_page.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:my_project/providers/user_provider.dart';
import 'package:my_project/units/dialog.dart';
import 'package:my_project/widgets/custom_navigation_bar.dart';
import 'package:my_project/widgets/profile_header.dart';
import 'package:my_project/widgets/setting_field.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<void> _userFuture;

  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().getUser(context.read<AuthProvider>().userId!);
  }

  void _edit() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) => RegisterPage(
          isRegister: false,
          id: context.read<AuthProvider>().userId,
        ),
      ),
    );
  }

  void _logOut() async {
    final confirm = await showConfirmDialog(context, 'logout');

    if (!mounted) return;

    if (!confirm!) return;

    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const LoginPage()),
    );
  }

  void _delete() async {
    context.read<UserProvider>().deleteUser(
      context.read<AuthProvider>().userId!,
    );

    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const LoginPage()),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          final User user = context.watch<UserProvider>().user!;

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: const TitlePageText(text: 'Profile'),
            ),
            body: Center(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 170,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ProfileHeader(
                      firstName: user.firstName,
                      lastName: user.lastName,
                      email: user.email,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      children: [
                        SettingField(
                          text: 'Edit',
                          icon: const Icon(Icons.edit),
                          func: _edit,
                        ),
                        const SizedBox(height: 20),
                        SettingField(
                          text: 'Log Out',
                          icon: const Icon(Icons.logout),
                          func: _logOut,
                        ),
                        const SizedBox(height: 20),
                        SettingField(
                          text: 'Delete Account',
                          icon: const Icon(Icons.delete, color: Colors.red),
                          func: _delete,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const CustomNavigationBar(
              currentPage: 'profile',
            ),
          );
        }
      },
    );
  }
}
