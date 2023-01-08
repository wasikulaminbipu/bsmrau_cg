import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProgressViewer extends StatelessWidget {
  final bool isError;

  const ProgressViewer({Key? key, required this.isError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Lottie.asset(
            isError
                ? 'assets/animations/error.zip'
                : 'assets/animations/calculator_loading.zip',
            height: 180.0),
        Text(
          isError ? 'No Internet...' : 'Loading States...',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.bold,
            letterSpacing: 5.0,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
