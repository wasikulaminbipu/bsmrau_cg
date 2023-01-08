import 'package:flutter/material.dart';

class ViewCard extends StatelessWidget {
  final Widget child;

  const ViewCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                blurRadius: 5.0,
                color: Theme.of(context).colorScheme.onBackground)
          ]),
      // child: StateViewer(
      //   isError: true,
      child: child,
    );
  }
}
