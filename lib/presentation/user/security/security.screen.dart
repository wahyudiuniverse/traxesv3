import 'package:flutter/material.dart';
import 'package:traxes/constant/text.style.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security", style: standarWhiteTextB),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C4966),
      ),
    );
  }
}