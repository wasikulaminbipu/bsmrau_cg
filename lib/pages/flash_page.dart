// import 'dart:async';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:bsmrau_cg/pages/calculator_page/calculator_page.dart';
// import 'package:bsmrau_cg/pages/initializer_page/initializer_page.dart';
// import 'package:bsmrau_cg/providers/calculator_provider.dart';
// import 'package:bsmrau_cg/providers/flash_provider.dart';
// import 'package:bsmrau_cg/providers/initializer_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';

// class FlashPage extends StatelessWidget {
//   const FlashPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     //initialize the state to start counting the animation
//     context.read<FlashState>().initialize();

//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 6,
//             ),
//             Center(
//                 child: Image.asset(
//               'assets/images/bsmrau_logo.png',
//               width: MediaQuery.of(context).size.height / 3,
//             )),
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 4,
//             ),
//             const AnimatedBottom(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AnimatedBottom extends StatelessWidget {
//   const AnimatedBottom({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //check if the state allows to nevigate and then nevigate to the next page
//     if (context.watch<FlashState>().navigateNextPage()) {
//       //Decide which page to nevigate
//       bool dbAvailable = context.read<FlashState>().checkDbAvailability();

//       //Create the Navigatable Page with state
//       var pageWidget = ChangeNotifierProvider(
//           create: (_) => dbAvailable ? CalculatorState() : InitializerState(),
//           builder: (context, child) {
//             dbAvailable
//                 ? context.read<CalculatorState>().initialize()
//                 : context.read<InitializerState>().initialize();
//             return dbAvailable
//                 ? const CalculatorPage()
//                 : const InitializerPage();
//           });
//       //Future is used to separate the nevigator from building process. this will prevent build errors
//       Future.delayed(Duration.zero, () {
//         Navigator.of(context)
//             .pushReplacement(MaterialPageRoute(builder: (_) => pageWidget));
//       });
//     }

//     return Container(
//       child: !context.watch<FlashState>().swapAnimation()
//           ? Center(
//               child: Lottie.asset('assets/animations/calculator_loading.zip',
//                   height: MediaQuery.of(context).size.height / 8))
//           : Container(
//               alignment: Alignment.center,
//               height: MediaQuery.of(context).size.height / 8,
//               child: AnimatedTextKit(
//                 animatedTexts: [
//                   ColorizeAnimatedText('BSMRAU CG',
//                       textStyle: const TextStyle(
//                           fontSize: 40.0,
//                           fontFamily: 'Horizon',
//                           fontWeight: FontWeight.bold),
//                       colors: [
//                         Colors.purple,
//                         Colors.blue,
//                         Colors.yellow,
//                         Colors.red,
//                         Colors.green
//                       ])
//                 ],
//                 isRepeatingAnimation: false,
//               ),
//             ),
//     );
//   }
// }
