import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFF297858),
            Color(0xFF033E27),
            Color(0xFF272727),
          ],
          stops: [0.0, 0.3, 0.7, 0.9],
        ),
      ),
      child: child,
    );
  }
}
