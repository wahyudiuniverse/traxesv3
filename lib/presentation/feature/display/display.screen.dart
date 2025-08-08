// ignore_for_file: use_build_context_synchronously

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
import 'package:traxes/bloc/feature/display/display.bloc.dart';
import 'package:traxes/constant/widget/customer.card.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/model/display/display.model.dart';

class DisplayScreen extends StatefulWidget {
  final String? customerName;
  final String? address;
  final String? customerId;
  const DisplayScreen(
      {super.key, this.customerName, this.address, this.customerId});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  File? imageDisplay;
  File? imageDisplay2;
  File? imageDisplay3;
  String? customerName;
  String? address;
  String? customerId;
  String? img64;
  String? img64Display2;
  String? img64Display3;

  Future<void> _showImagePickerOptions(Function(ImageSource) onImageSelected) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  onImageSelected(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  onImageSelected(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getImageDisplay() async {
    _showImagePickerOptions((ImageSource source) async {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400,
      );
      setState(() {
        if (pickedFile != null) {
          imageDisplay = File(pickedFile.path);
          final bytes = imageDisplay!.readAsBytesSync();
          img64 = base64Encode(bytes);
        } else {
          EasyLoading.showError("Fotonya mana?",
              duration: const Duration(seconds: 3));
        }
      });
    });
  }

  Future<void> getImageDisplay2() async {
    _showImagePickerOptions((ImageSource source) async {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400,
      );
      setState(() {
        if (pickedFile != null) {
          imageDisplay2 = File(pickedFile.path);
          final bytes = imageDisplay2!.readAsBytesSync();
          img64Display2 = base64Encode(bytes);
        } else {
          EasyLoading.showError("Fotonya mana?",
              duration: const Duration(seconds: 3));
        }
      });
    });
  }

  Future<void> getImageDisplay3() async {
    _showImagePickerOptions((ImageSource source) async {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400,
      );
      setState(() {
        if (pickedFile != null) {
          imageDisplay3 = File(pickedFile.path);
          final bytes = imageDisplay3!.readAsBytesSync();
          img64Display3 = base64Encode(bytes);
        } else {
          EasyLoading.showError("Fotonya mana?",
              duration: const Duration(seconds: 3));
        }
      });
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
          "Display",
          style: standarWhiteTextB,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 15, bottom: 8),
          child: Column(
            children: [
               CustomerInfoCard(
                        customerId: widget.customerId.toString(),
                        customerName: widget.customerName.toString(),
                        address: widget.address.toString(),
                       ),
                       const SizedBox(height: 30,),
              Text(
                "Masukkan foto display",
                style: standarBlackTextB,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Before",
                        style: smallBlackTextB,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: Get.width / 3.8,
                        height: 100,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1.0, color: Colors.black26),
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () {
                            getImageDisplay();
                          },
                          child: imageDisplay == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt,
                                      size: 70,
                                      color: Color(0x404D6633),
                                    ),
                                    Text(
                                      "Foto before",
                                      style: smallColorFontGrey,
                                    )
                                  ],
                                )
                              : Image.file(
                                  imageDisplay!,
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
                const SizedBox(
                  width: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "After",
                        style: smallBlackTextB,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: Get.width / 3.8,
                        height: 100,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1.0, color: Colors.black26),
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () {
                            getImageDisplay2();
                          },
                          child: imageDisplay2 == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt,
                                      size: 70,
                                      color: Color(0x404D6633),
                                    ),
                                    Text(
                                      "Foto after",
                                      style: smallColorFontGrey,
                                    )
                                  ],
                                )
                              : Image.file(
                                  imageDisplay2!,
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
              ]),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: Get.width / 0.8,
                      child: CustomButton(
                          borderRadius: BorderRadius.circular(8),
                          width: double.infinity,
                          onPressed: () async {
                            var connectivityResult =
                                await Connectivity().checkConnectivity();

                            if (img64 == null) {
                              EasyLoading.showError(
                                "Minimal 1 foto display harus diisi",
                                duration: const Duration(seconds: 3),
                              );
                            } else if (connectivityResult
                                .contains(ConnectivityResult.none)) {
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
                            } else {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var createdBy = prefs.getString("empid");
                              CoolAlert.show(
                                  confirmBtnColor: const Color(0xFF661C63),
                                  confirmBtnText: "Input Display",
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
                                    var data = DisplayModel(
                                        display: img64,
                                        display2: img64Display2,
                                        createdBy:
                                            int.parse(createdBy.toString()),
                                        idToko: widget.customerId);
                                    context
                                        .read<DisplayBloc>()
                                        .sendDisplay(data, context);
                                  });
                            }
                          },
                          child: Text(
                            "Update display",
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
