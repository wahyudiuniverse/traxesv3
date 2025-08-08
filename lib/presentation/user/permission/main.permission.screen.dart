
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/absence/absence.screen.dart';
import 'package:traxes/presentation/user/permission/leave/leave.permission.screen.dart';
import 'package:traxes/presentation/user/permission/offday/offday.permission.screen.dart';
import 'package:traxes/presentation/user/permission/permission/permission.screen.dart';
import 'package:traxes/presentation/user/permission/sick/sick.permission.dart';

class PermissionMainScreen extends StatefulWidget {
  final String? customerId;
  final String? latToko;
  final String? longToko;
  const PermissionMainScreen(
      {super.key, this.customerId, this.latToko, this.longToko});

  @override
  State<PermissionMainScreen> createState() => _PermissionMainScreenState();
}

class _PermissionMainScreenState extends State<PermissionMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Izin", style: standarWhiteTextB),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var checkData = prefs.getString("empid");

                    if (checkData == null) {
                      Get.to(const AbsenceScreen());
                    } else {
                      Get.to(const PermissionScreen());
                    }
                    // prefs.clear();
                  },
                  child: Card(
                    color: const Color(0xFFE1C16E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.more_time,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Izin",
                              style: standarWhiteText,
                            )
                          ],
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var checkData = prefs.getString("empid");

                    if (checkData == null) {
                      Get.to(const AbsenceScreen());
                    } else {
                      Get.to(const SickPermissionScreen());
                    }
                    // prefs.clear();
                  },
                  child: Card(
                    color: const Color(0xFF7B1818),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.local_hospital,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text("Absen Sakit", style: standarWhiteText)
                          ],
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var checkData = prefs.getString("empid");

                    if (checkData == null) {
                      Get.to(const AbsenceScreen());
                    } else {
                      Get.to(const LeavePermissionScreen());
                    }
                    // prefs.clear();
                  },
                  child: Card(
                    color: const Color(0xFF5F8575),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.hail,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Absen Cuti",
                              style: standarWhiteText,
                            )
                          ],
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var checkData = prefs.getString("empid");

                    if (checkData == null) {
                      Get.to(const AbsenceScreen());
                    } else {
                      Get.to(const OffDayScreen());
                    }
                    // prefs.clear();
                  },
                  child: Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.highlight_off_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text("Off Day", style: standarWhiteText)
                          ],
                        )),
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(top: 25),
              //   child: GestureDetector(
              //   onTap: () async {
              //     SharedPreferences prefs =
              //         await SharedPreferences.getInstance();
              //     var checkData = prefs.getString("empid");

              //     if (checkData == null) {
              //       Get.to(const AbsenceScreen());
              //     } else {
              //       Get.to(const OvertimeScreen());
              //     }
              //     // prefs.clear();
              //   },
              //   child: Card(
              //     color: const Color(0xFF0818A8),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15)),
              //     child: Container(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             const Icon(
              //               Icons.punch_clock,
              //               size: 60,
              //               color: Colors.white,
              //             ),
              //             const SizedBox(
              //               height: 25,
              //             ),
              //             Text("Lembur", style: standarWhiteText)
              //           ],
              //         ),
              //         width: MediaQuery.of(context).size.width / 1.2,
              //         height: 150),
              //   ),
              //                 ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
