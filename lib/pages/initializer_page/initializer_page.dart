import 'package:bsmrau_cg/pages/initializer_page/info_collector.dart';
import 'package:bsmrau_cg/providers/initializer_provider.dart';
import 'package:bsmrau_cg/widgets/view_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class InitializerPage extends StatelessWidget {
  const InitializerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
        shrinkWrap: false,
        children: [
          Lottie.asset(
            'assets/animations/initializer.zip',
            frameRate: FrameRate.max,
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.06,
          // ),
          //Main Box
          const ViewCard(
            child: InfoCollector(),
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.06,
          // ),
          const SizedBox(
            height: 20.0,
          ),
          const Text("Can't Find Yours? Contact", textAlign: TextAlign.center),
          ContactsSection(),
        ],
      ),
    ));
  }
}

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
              child: Icon(Icons.message_outlined)),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
              onPressed: state.contactMail, child: Icon(Icons.mail_outline)),
        ],
      ),
    );
  }
}
