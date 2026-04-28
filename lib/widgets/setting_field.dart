import 'package:flutter/material.dart';

class SettingField extends StatelessWidget {
  const SettingField({
    required this.text,
    required this.icon,
    required this.func,
    super.key,
  });

  final String text;
  final Icon icon;
  final void Function() func;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(child: Text(text)),
            icon,
          ],
        ),
      ),
    );
  }
}
