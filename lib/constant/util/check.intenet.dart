import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:traxes/constant/text.style.dart';


class ConnectivityHelper {
  static bool isDialogShowing = false;
  static StreamSubscription<InternetConnectionStatus>? internetSubscription;
  static BuildContext? dialogContext;

  static Future<void> checkConnectivity(BuildContext context, VoidCallback onPressed) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none) && !isDialogShowing) {
      if (!context.mounted) return;
      showNoInternetDialog(context, onPressed);
    } else {
      hideNoInternetDialog();
    }

    internetSubscription?.cancel();
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {
        if (isDialogShowing) {
          hideNoInternetDialog();
        }
      } else {
        showNoInternetDialog(context, onPressed);
      }
    });
  }

  static void showNoInternetDialog(BuildContext context, VoidCallback onPressed) {
    if (!isDialogShowing) {
      isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context; // Set dialog
          return AlertDialog(
            title: Text('No Internet Connection', style: largeBlackText),
            content: Text('Please check your internet connection and try again.', style: standarBlackText),
            actions: [
              TextButton(
                onPressed: () {
                  isDialogShowing = false;
                  Navigator.of(context).pop();
                  onPressed();
                },
                child: Text('OK', style: smallBlackText),
              ),
            ],
          );
        },
      );
    }
  }

  static void hideNoInternetDialog() {
    if (isDialogShowing && dialogContext != null) {
      isDialogShowing = false;
      Navigator.of(dialogContext!).pop(); // Close dialog
    }
  }

  static void setDialogContext(BuildContext context) {
    dialogContext = context;
  }

  static void dispose() {
    internetSubscription?.cancel();
  }
}