// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:traxes/constant/text.style.dart';

class DialogUtils {

  void showRetryDialogSubmit( BuildContext context,) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Timeout', style: largeBlackText),
            content: Text('Connection timed out', style: standarBlackTextB),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    }
  } 
  
//   void showRetryDialog({
//     required BuildContext context,
//     required Future<void> Function() onRetry,
//     int retryCount = 0,
//     required int maxRetries,
//   }) {
//     if (context.mounted) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Timeout', style: largeBlackText),
//             content: Text('Connection timed out. Do you want to retry?',
//                 style: standarBlackTextB),
//             actions: [
//               TextButton(
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   await onRetry(); // Call the onRetry callback
//                 },
//                 child: Text('Coba lagi', style: TextStyle(color: Colors.blue)),
//               ),
//             ],
//           );
//         },
//       ).then((_) async {
//         if (retryCount < maxRetries) {
//           await onRetry(); // Ensure retry on dialog close
//         }
//       });
//     }
//   }
// }
}