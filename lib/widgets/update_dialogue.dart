import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UpdateDialogue extends StatelessWidget {
  final void Function() onRemindMe;
  final void Function() onDownload;

  const UpdateDialogue(
      {super.key, required this.onRemindMe, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Version Available'),
      content: Text(
          'New Version of the app available. Please Download the app and be updated'),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        ElevatedButton(onPressed: onRemindMe, child: const Text('Remind Me')),
        ElevatedButton(onPressed: onDownload, child: const Text('Update')),
      ],
    );
  }
}
