import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({required this.text, required this.func, super.key});

  final String text;
  final void Function() func;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.func,
      child: Expanded(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFF033E27),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            )
          )
        )
      )
    );
  }
}
