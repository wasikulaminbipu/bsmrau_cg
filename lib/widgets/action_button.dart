import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          elevation: 10.0,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10.0),
          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width / 10)),
      child: Icon(icon),
    );
  }
}
