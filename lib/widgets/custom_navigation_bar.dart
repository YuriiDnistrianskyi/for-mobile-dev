import 'package:flutter/material.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/profile_page.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({required this.currentPage, super.key});

  final String currentPage;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void _navigateToSetting() {
    if (widget.currentPage != 'setting') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (context) => const
      //   )
      // )
    }
  }

  void _navigateToHome() {
    if (widget.currentPage != 'home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (context) => const HomePage()),
      );
    }
  }

  void _navigateToProfile() {
    if (widget.currentPage != 'profile') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (context) => const ProfilePage()),
      );
    }
  }

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
              onPressed: _navigateToSetting,
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: _navigateToHome,
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.account_box),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: _navigateToProfile,
            ),
          ],
        ),
      ),
    );
  }
}
