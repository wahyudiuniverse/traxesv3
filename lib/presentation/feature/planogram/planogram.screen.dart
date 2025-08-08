// ignore_for_file: use_build_context_synchronously, unused_import
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/planogram/planogram.bloc.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/customer.card.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/model/planogram/planogram.model.dart';
import 'package:traxes/presentation/feature/absence/absence.screen.dart';

class PlanogramScreen extends StatefulWidget {
  final String? customerName;
  final String? address;
  final String? customerId;
  const PlanogramScreen(
      {super.key, this.customerName, this.address, this.customerId});

  @override
  State<PlanogramScreen> createState() => _PlanogramScreenState();
}

class _PlanogramScreenState extends State<PlanogramScreen> {
  File? imagePlanogram;
  File? imagePlanogram2;
  File? imagePlanogram3;
  String? customerName;
  String? address;
  String? customerId;
  String? img64;
  String? img64Display2;
  String? img64Display3;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getImagePlanogram() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imagePlanogram = File(pickedFile.path);
        final bytes = imagePlanogram!.readAsBytesSync();
        img64 = base64Encode(bytes);
      } else if (pickedFile == null) {
        EasyLoading.showError("Fotonya mana?",
            duration: const Duration(seconds: 3));
      }
    });
  }

  void getImagePlanogram2() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imagePlanogram2 = File(pickedFile.path);
        final bytes = imagePlanogram2!.readAsBytesSync();
        img64Display2 = base64Encode(bytes);
      } else if (pickedFile == null) {
        EasyLoading.showError("Fotonya mana?",
            duration: const Duration(seconds: 3));
      }
    });
  }

  void getImagePlanogram3() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imagePlanogram3 = File(pickedFile.path);
        final bytes = imagePlanogram3!.readAsBytesSync();
        img64Display3 = base64Encode(bytes);
      } else if (pickedFile == null) {
        EasyLoading.showError("Fotonya mana?",
            duration: const Duration(seconds: 3));
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Planogram",
          style: standarWhiteTextB,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 15, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             CustomerInfoCard(customerName: widget.customerName.toString(), address: widget.address.toString(), customerId: widget.customerId.toString()),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Masukkan 3 foto planogram",
                style: standarBlackTextB,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            key: formKey,
                            child: Container(
                              width: Get.width / 3.8,
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: Colors.black26),
                                  borderRadius: BorderRadius.circular(15)),
                              child: InkWell(
                                onTap: () {
                                  getImagePlanogram();
                                },
                                child: imagePlanogram == null
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.camera_alt,
                                            size: 70,
                                            color: Color(0x404D6633),
                                          ),
                                          Text(
                                            "Foto 1",
                                            style: smallColorFontGrey,
                                          )
                                        ],
                                      )
                                    : Image.file(
                                        imagePlanogram!,
                                        width: 170,
                                        height: 170,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: Get.width / 3.8,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: Colors.black26),
                                borderRadius: BorderRadius.circular(15)),
                            child: InkWell(
                              onTap: () {
                                getImagePlanogram2();
                              },
                              child: imagePlanogram2 == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.camera_alt,
                                          size: 70,
                                          color: Color(0x404D6633),
                                        ),
                                        Text(
                                          "Foto 2",
                                          style: smallColorFontGrey,
                                        )
                                      ],
                                    )
                                  : Image.file(
                                      imagePlanogram2!,
                                      width: 170,
                                      height: 170,
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: Get.width / 3.8,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: Colors.black26),
                                borderRadius: BorderRadius.circular(15)),
                            child: InkWell(
                              onTap: () {
                                getImagePlanogram3();
                              },
                              child: imagePlanogram3 == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.camera_alt,
                                          size: 70,
                                          color: Color(0x404D6633),
                                        ),
                                        Text(
                                          "Foto 3",
                                          style: smallColorFontGrey,
                                        )
                                      ],
                                    )
                                  : Image.file(
                                      imagePlanogram3!,
                                      width: 170,
                                      height: 170,
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(8),
                          onPressed: () async {
                            var connectivityResult =
                                await Connectivity().checkConnectivity();

                            if (img64 == null) {
                              EasyLoading.showError(
                                "Minimal 1 foto planogram harus diisi",
                                duration: const Duration(seconds: 3),
                              );
                            } else if(connectivityResult.contains(ConnectivityResult.none)) {
                               showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return PopScope(
                                  canPop: false,
                                  child: AlertDialog(
                                    title: Text('No Internet Connection',
                                        style: largeBlackText),
                                    content: Text(
                                        'Please check your internet connection and try again.',
                                        style: standarBlackText),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child:
                                            Text('OK', style: smallBlackText),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            }else {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var createdBy = prefs.getString("empid");
                              CoolAlert.show(
                                  confirmBtnColor: const Color(0xFF661C63),
                                  confirmBtnText: "Input Planogram",
                                  confirmBtnTextStyle: smallWhiteText,
                                  cancelBtnText: "Kembali",
                                  cancelBtnTextStyle: smallColorFontGrey,
                                  backgroundColor: const Color(0xFF661C63),
                                  animType: CoolAlertAnimType.slideInUp,
                                  title: "Apakah foto nya sudah sesuai ?",
                                  titleTextStyle: standarBlackText,
                                  context: context,
                                  type: CoolAlertType.confirm,
                                  onConfirmBtnTap: () {
                                    var data = PlanogramModel(
                                      planogram: img64,
                                      planogram2: img64Display2,
                                      planogram3: img64Display3,
                                      createdby:
                                          int.parse(createdBy.toString()),
                                      idToko: widget.customerId,
                                    );
                                    context
                                        .read<PlanogramBloc>()
                                        .sendPlanogram(data, context);
                                  });
                            }
                          },
                          child: Text(
                            "Update Planogram",
                            style: smallWhiteText,
                          )),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
