import 'package:bsmrau_cg/pages/initializer_page/info_collector.dart';
import 'package:bsmrau_cg/widgets/contact_section.dart';
import 'package:bsmrau_cg/widgets/view_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
          //Main Box
          const ViewCard(
            child: InfoCollector(),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text("Can't Find Yours? Contact", textAlign: TextAlign.center),
          const ContactsSection(),
        ],
      ),
    ));
  }
}
