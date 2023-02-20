

// abstract class NetworkHelper {
 
//   //============================================================================
//   //------------------------Private Functions-----------------------------------
//   //============================================================================
//   static Error registerError(Error error) {
//     if (error == _error) return;

//     if (_error.index < error.index) {
//       _error = error;
//     }
//   }

//   static Error removeError(Error error) {
//     if (error == _error) {
//       _error = Error.noError;
//     }
//   }

//   Future<void> _recursiveFunctions(
//       {bool Function()? stopCondition,
//       void Function()? runAfter,
//       required Future<void> Function() function}) async {
//     if (stopCondition!()) return;

//     ConnectivityResult connectivityResult =
//         await (Connectivity().checkConnectivity());

//     //Check whether connection state has changed or not and notify listeners for state changes

//     if (connectivityResult != ConnectivityResult.wifi &&
//         connectivityResult != ConnectivityResult.mobile) {
//       _registerError(Error.noInternet);
//     } else {
//       _removeError(Error.noInternet);
//     }

//     //Try to use the function
//     if (_error != Error.noInternet) {
//       try {
//         await function();
//         _removeError(Error.connectionError);
//       } catch (e) {
//         _registerError(Error.connectionError);
//       }
//     }

//     //Check whether the condition has met or not

//     if (stopCondition()) {
//       _error = Error.noError;
//       runAfter!();
//     } else {
//       notifyListeners();
//       _recursiveFunctions(
//           function: function, stopCondition: stopCondition, runAfter: runAfter);
//     }
//   }
// }

// enum Error {
//   noError,
//   databaseError,
//   downloadError,
//   connectionError,
//   noInternet
// }
