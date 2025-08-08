// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traxes/constant/screen/full.image.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/dashboard/dashboard.screen.dart';
import 'package:traxes/presentation/user/activity.screen.dart';

class SuccessOutScreen extends StatelessWidget {
  final String? toko;
  final String? alamat;
  final String? currentDate;
  final String? tdata;
  final String? name;
  final String? jabatan;
  final Uint8List? watermarkedImgBytes;

  const SuccessOutScreen({
    super.key,
    this.toko,
    this.alamat,
    this.currentDate,
    this.tdata,
    this.name,
    this.jabatan,
    this.watermarkedImgBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            Get.offAll(const EmployeeScreen());
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 80,
                      ),
                      const SizedBox(height: 10),
                      Text('Check-out berhasil', style: extraLargeBlackTextB),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: () {
                                Get.to(FullScreenImageScreen(
                                    imageBytes: watermarkedImgBytes!));
                              },
                              child: Image.memory(
                                watermarkedImgBytes!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "$name",
                        style: extraLargeBlackTextB,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '$jabatan',
                        style: extraLargeBlackTextB,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tanggal: $currentDate\njam: $tdata',
                        style: standarBlackTextB,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(const DashboardScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Kembali ke menu aktivitas'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
