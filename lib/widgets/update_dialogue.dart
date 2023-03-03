import 'package:flutter/material.dart';

class UpdateDialogue extends StatelessWidget {
  final void Function()? onRemindMe;
  final void Function() onDownload;
  final void Function()? onCancel;

  const UpdateDialogue(
      {super.key, this.onRemindMe, required this.onDownload, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Version Available'),
      content: const Text(
          'New Version of the app available. Please Download the app and be updated'),
      // actionsOverflowAlignment: OverflowBarAlignment.right,
      actions: [
        ElevatedButton(onPressed: onDownload, child: const Text('Update')),
        Visibility(
            visible: onRemindMe != null,
            child: ElevatedButton(
                onPressed: onRemindMe, child: const Text('Remind Me'))),
        Visibility(
          visible: onCancel != null,
          child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
        ),
      ],
    );
  }
}
