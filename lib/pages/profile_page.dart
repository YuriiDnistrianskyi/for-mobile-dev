import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/user/user_cubit.dart';
import 'package:my_project/cubit/user/user_state.dart';
import 'package:my_project/pages/login_page.dart';
import 'package:my_project/pages/register_page.dart';
import 'package:my_project/units/dialog.dart';
import 'package:my_project/widgets/custom_navigation_bar.dart';
import 'package:my_project/widgets/profile_header.dart';
import 'package:my_project/widgets/setting_field.dart';
import 'package:my_project/widgets/title_page_text.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<UserCubit>(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          final user = state.user!; //

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
                          func: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => RegisterPage(
                                  isRegister: false,
                                  id: context.read<AuthCubit>().state.userId,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SettingField(
                          text: 'Log Out',
                          icon: const Icon(Icons.logout),
                          func: () async {
                            final confirm = await showConfirmDialog(
                              context,
                              'logout',
                            );

                            if (!context.mounted) return;

                            if (!confirm!) return;

                            Provider.of<AuthCubit>(
                              context,
                              listen: false,
                            ).logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SettingField(
                          text: 'Delete Account',
                          icon: const Icon(Icons.delete, color: Colors.red),
                          func: () {
                            context.read<UserCubit>().deleteUser(
                              context.read<AuthCubit>().state.userId!,
                            );

                            Provider.of<AuthCubit>(
                              context,
                              listen: false,
                            ).logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => const LoginPage(),
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Account deleted')),
                            );
                          },
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
        },
      ),
    );
  }
}
