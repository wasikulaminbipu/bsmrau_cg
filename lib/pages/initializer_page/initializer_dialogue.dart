// import 'package:bsmrau_cg/pages/calculator_page/calculator_page.dart';
// import 'package:bsmrau_cg/providers/initializer_provider.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';

// class InitializerDialogue extends StatelessWidget {
//   const InitializerDialogue({super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (context.watch<InitializerState>().isReady) {
//       Future.delayed(
//           Duration.zero,
//           () => Navigator.of(context)
//               .push(MaterialPageRoute(builder: (_) => const CalculatorPage())));
//     }
//     return SimpleDialog(
//       title: const Center(child: Text('BSMRAU CG')),
//       alignment: Alignment.center,
//       // titleTextStyle: TextStyle(),
//       children: [
//         Center(
//             child: Lottie.asset('assets/animations/calculator_loading.zip',
//                 height: MediaQuery.of(context).size.height / 8)),
//         Center(
//           child: Text(''),
//         )
//       ],
//     );
//   }
// }
