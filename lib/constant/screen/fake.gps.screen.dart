import 'package:flutter/material.dart';
import 'package:traxes/constant/text.style.dart';

class FakeGPSWarningScreen extends StatelessWidget {
  const FakeGPSWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(    
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Image.asset(
                          "assets/images/alarm.png",
                          color: const Color(0xFF661C63),
                          width: 120,
                          height: 90),
                      const SizedBox(
                        height: 25,
                      ),
           Text(
              "Fake GPS Terdeteksi",
              style: largeBlackText 
            ),
           Padding(
             padding: const EdgeInsets.only(left: 8),
             child: Text(
                "Harap nonaktifkan aplikasi fake GPS jika \n ingin melanjutkan ke dalam aplikasi",
                style: smallBlackText
              ),
           ),
          ],
        ),
      ),
    );
  }
}