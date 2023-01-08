import 'package:bsmrau_cg/pages/initializer_page/info_collector.dart';
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
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.06,
          // ),
          //Main Box
          const ViewCard(
            child: InfoCollector(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
        ],
      ),
    ));
  }
}