import 'package:bsmrau_cg/providers/initializer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsSection extends StatelessWidget {
  const ContactsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<InitializerState>();

    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: state.contactCall, child: Icon(Icons.call)),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
              onPressed: state.contactMessage,
              child: const Icon(Icons.message_outlined)),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
              onPressed: state.contactMail,
              child: const Icon(Icons.mail_outline)),
        ],
      ),
    );
  }
}
