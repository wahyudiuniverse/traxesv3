import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.network(
        'https://assets10.lottiefiles.com/packages/lf20_usmfx6bp.json',
        width: 100,
        height: 100,
        fit: BoxFit.fill,
      ),
    );
  }
}