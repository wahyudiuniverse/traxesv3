import 'package:flutter/material.dart';
import 'package:traxes/constant/text.style.dart';

class WarningScreen extends StatelessWidget {
  final String warningText;
  final IconData icon;
  final String buttonText;
  final VoidCallback onPressed;

  const WarningScreen({
    super.key,
    required this.warningText,
    required this.icon,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 50,
          color: Colors.amber,
        ),
        const SizedBox(height: 20),
        Text(
          warningText,
          style: standarBlackText,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
