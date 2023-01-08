// import 'package:flutter/material.dart';

// class StageViewer extends StatelessWidget {
//   final IconData icon;
//   final bool isActive;

//   const StageViewer({Key? key, required this.icon, required this.isActive})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 500),
//       height: isActive
//           ? MediaQuery.of(context).size.height / 7
//           : MediaQuery.of(context).size.height / 10,
//       width: MediaQuery.of(context).size.width / 4.7,
//       padding: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//           color: Theme.of(context).primaryColor,
//           borderRadius: BorderRadius.circular(20.0),
//           boxShadow: [
//             BoxShadow(
//                 blurRadius: isActive ? 15.0 : 5.00,
//                 color: Theme.of(context).shadowColor)
//           ]),
//       child: Icon(
//         icon,
//         size: MediaQuery.of(context).size.height / 20,
//       ),
//     );
//   }
// }
