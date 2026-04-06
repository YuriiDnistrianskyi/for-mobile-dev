import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context, String text) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm'),
        content: Text('Conform $text ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'No',
              style: TextStyle(color: Color(0xFF033E27),)
            )
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Yes', 
              style: TextStyle(color: Color(0xFF033E27)),
            ),
          )
        ],
      );
    }
  );
}
