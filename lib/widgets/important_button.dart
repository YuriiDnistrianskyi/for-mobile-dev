import 'package:flutter/material.dart';

class ImportantButton extends StatefulWidget {
  const ImportantButton({required this.text, required this.func, super.key});

  final String text;
  final void Function() func;

  @override
  State<ImportantButton> createState() => _ImportantButtonState();
}

class _ImportantButtonState extends State<ImportantButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.func,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF033E27),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Text(widget.text),
    );
  }
}
