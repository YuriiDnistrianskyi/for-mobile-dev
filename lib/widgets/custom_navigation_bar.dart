import 'package:flutter/material.dart';
import 'package:my_project/cubit/user/user_cubit.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/profile_page.dart';
import 'package:my_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({required this.currentPage, super.key});

  final String currentPage;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsetsGeometry.all(15),
        child: OverflowBar(
          overflowAlignment: OverflowBarAlignment.center,
          alignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: () {
                if (currentPage != 'setting') {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute<void>(
                  //     builder: (context) => const
                  //   )
                  // )
                }
              },
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: () {
                if (currentPage != 'home') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const HomePage(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.account_box),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: () {
                final id = context.read<AuthProvider>().userId!;
                context.read<UserCubit>().getUser(id);
                if (currentPage != 'profile') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
