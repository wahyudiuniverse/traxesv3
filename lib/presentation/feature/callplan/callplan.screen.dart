// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/constant/screen/fake.gps.screen.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/absence/check-out/checkout.absence.screen.dart';
import 'package:traxes/presentation/feature/callplan/plan.screen.dart';

class CallPlanScreen extends StatefulWidget {
  const CallPlanScreen({super.key});

  @override
  State<CallPlanScreen> createState() => _CallPlanScreenState();
}

class _CallPlanScreenState extends State<CallPlanScreen> {
  String? customerName;
  String? nik;
  String? customerId;
  String? address;
  Position? position;
  String? latToko;
  String? longToko;

  void callNik() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nik = prefs.getString("empid").toString();
    });
  }

  void getCustomerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerName = prefs.getString("customerName").toString();
    });
  }

  void getCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getString("customerId").toString();
    });
  }

  void getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString("address").toString();
    });
  }

  void getLatToko() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      latToko = prefs.getString("latitudeToko").toString();
    });
  }

  void getLongToko() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      longToko = prefs.getString("longitudeToko").toString();
    });
  }

  Future<void> getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();

    if (position!.isMocked) {
      Get.offAll(const FakeGPSWarningScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getCustomerName();
    getCustomerId();
    getAddress();
    getCurrentLocation();
    getLatToko();
    getLongToko();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1C4966),
        title: Text("Call Plan Screen", style: standarWhiteTextB),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 55, top: 110),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var checkData = prefs.getString("empid");
                    var checkCheckin = prefs.getInt("getIn");

                    if (checkData == null) {
                      Get.to(const CallPlanScreen());
                    } else if (checkCheckin == 1) {
                      // ignore: use_build_context_synchronously
                      CoolAlert.show(
                          backgroundColor: const Color(0xFFFFFFFF),
                          title: "Check-out terlebih dahulu",
                          confirmBtnColor: const Color(0xFF661C63),
                          confirmBtnText: "Kembali",
                          confirmBtnTextStyle: smallWhiteText,
                          titleTextStyle: standarBlackText,
                          context: context,
                          type: CoolAlertType.error);
                    } else {
                      Get.to(const PlanScreen());
                    }
                    // prefs.clear();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Card(
                      color: const Color(0xFF00A36C),
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
                                Icons.login,
                                size: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                "Check-in",
                                style: standarWhiteText,
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  //   Get.to(CheckOutAbsenceScreen(
                  //   alamat: address,
                  //   customerId: customerId,
                  //   toko: customerName,
                  //   latToko: latToko,
                  //   longToko: longToko,
                  // ));
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var checkCheckin = prefs.getInt("getCio");

                  if (checkCheckin == null) {
                    // ignore: use_build_context_synchronously
                    CoolAlert.show(
                        backgroundColor: const Color(0xFFFFFFFF),
                        title: "Check-in terlebih dahulu",
                        confirmBtnColor: const Color(0xFF661C63),
                        confirmBtnText: "Kembali",
                        confirmBtnTextStyle: smallWhiteText,
                        titleTextStyle: standarBlackText,
                        context: context,
                        type: CoolAlertType.error);
                  } else {
                    Get.to(CheckOutAbsenceScreen(
                      alamat: address,
                      customerId: customerId,
                      toko: customerName,
                      latToko: latToko,
                      longToko: longToko,
                    ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 10),
                  child: Card(
                    color: const Color(0xFFC41E3A),
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
                              Icons.logout_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text("Check-out", style: standarWhiteText)
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
