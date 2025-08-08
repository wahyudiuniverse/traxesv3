import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/dashboard/dashboard.screen.dart';
import 'package:traxes/presentation/user/activity.screen.dart';
import 'package:traxes/presentation/user/login.employee.screen.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  Timer? timerCheck;
    int? checkedIn;

  // bool? showProgress = true;

   void checkCheckin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkedIn = prefs.getInt("getIn");
    });
  }

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? checkLogin = prefs.getBool("login");
    
     
   timerCheck = Timer(
        const Duration(milliseconds: 500),
        () {
              if (checkLogin == null)
                {Get.offAll(const LoginEmployeeScreen());}
              else
                {
                  if(checkedIn != 1) {
                     Get.offAll(const DashboardScreen(
                  ));
                  } else {
                    Get.offAll(const EmployeeScreen());
                  }
                }
            });
  } // --> function for timer login and validation login

  @override
  void initState() {
    super.initState();
    checkLogin();
    checkCheckin();
  }

  @override
  void dispose() {
    super.dispose();
    timerCheck?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Column(
            children: [
              Transform.scale(
                  scale: 0.8,
                  child: Image.asset("assets/images/traxes-icon.png",
                      fit: BoxFit.cover, height: 250)),
              const SizedBox(
                height: 20,
              ),
            ],
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "\u00a9 2023 OneCorp All Rights Reserved",
              style: extraSmallBlackText,
            ),
          ),
        ],
      ),
    );
  }
}