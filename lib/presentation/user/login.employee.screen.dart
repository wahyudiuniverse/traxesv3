// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/model/login/login.employee.model.dart';
import 'package:traxes/presentation/dashboard/dashboard.screen.dart';

class LoginEmployeeScreen extends StatefulWidget {
  const LoginEmployeeScreen({super.key});

  @override
  State<LoginEmployeeScreen> createState() => _LoginEmployeeScreenState();
}

class _LoginEmployeeScreenState extends State<LoginEmployeeScreen> {
  final GlobalKey<FormState> formBuilderKey = GlobalKey<FormState>();
  final nikController = TextEditingController();
  String enteredText = "";
  String? versionApp;

  @override
  void dispose() {
    super.dispose();
    nikController.dispose();
  }

  void getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final version = packageInfo.version;

    setState(() {
      versionApp = version;
    });
  }

  //  void checkConnectivityAndNavigate() {
  //   ConnectivityHelper.checkConnectivity(context, () {
  //     setState(() {
  //       ConnectivityHelper.hideNoInternetDialog();
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = context.read<EmployeeBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF1C4966),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: formBuilderKey,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 20),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: ClipOval(
                              child: Image.asset(
                                "assets/images/traxes-icon.png",
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "TRAXES",
                          style: largeWhiteTextB,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "Harap masukkan NIP dengan benar",
                          style: smallWhiteText,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 30, right: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("*Masukkan NIP",
                                            style: smallBlackText),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                          top: 20,
                                          bottom: 20),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Color(0xFF1C4966)),
                                        cursorColor: const Color(0xFF1C4966),
                                        validator: (v) {
                                          if (v!.isEmpty) {
                                            return "Harap isi NIP";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: nikController,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(8)
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            enteredText = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon:
                                              const Icon(Icons.check_box),
                                          suffixIconColor:
                                              enteredText.length == 8
                                                  ? Colors.green
                                                  : Colors.grey,
                                          hintText: "NIP",
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF1C4966)),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              alignment: Alignment.center,
                                              backgroundColor:
                                                  const Color(0xFF1C4966),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                          onPressed: () async {
                                            var connectivityResult =
                                                await Connectivity()
                                                    .checkConnectivity();

                                            if (connectivityResult.contains(
                                                ConnectivityResult.none)) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return PopScope(
                                                    canPop: false,
                                                    child: AlertDialog(
                                                      title: Text(
                                                          'No Internet Connection',
                                                          style:
                                                              largeBlackText),
                                                      content: Text(
                                                          'Please check your internet connection and try again.',
                                                          style:
                                                              standarBlackText),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('OK',
                                                              style:
                                                                  smallBlackText),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              if (formBuilderKey.currentState!
                                                  .validate()) {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setBool("login", true);
                                                var data = LoginModel(
                                                  nik: nikController.text,
                                                );
                                                loginVM.loginEmployee(
                                                    formData: data,
                                                    onSuccess: () async {
                                                      Get.offAll(
                                                          const DashboardScreen());
                                                    },
                                                    onFailed: (bodyMessage) {
                                                      String userInputText =
                                                          nikController.text;
                                                      CoolAlert.show(
                                                        context: context,
                                                        type:
                                                            CoolAlertType.error,
                                                        title: "Login gagal",
                                                        titleTextStyle:
                                                            largeBlackTextB,
                                                        text:
                                                            "$bodyMessage \n NIP: $userInputText",
                                                        textTextStyle:
                                                            standarBlackText,
                                                        confirmBtnText: "OK",
                                                        confirmBtnColor:
                                                            const Color(
                                                                0xFF1C4966),
                                                      );
                                                    });
                                              }
                                            }
                                          },
                                          child: Text(
                                            "Log in",
                                            style: smallWhiteTextB,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Versi : $versionApp",
              style: smallWhiteText,
            ),
          ),
        ],
      ),
    );
  }
}
