import 'package:flutter/material.dart';

class CustomAlertDialogue extends StatelessWidget {
  const CustomAlertDialogue(
      {super.key, required this.details, required this.onPressed});

  final String details;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Alert! "),
      content: Text(details),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context), child: const Text('OK'))
      ],
    );
  }
}
