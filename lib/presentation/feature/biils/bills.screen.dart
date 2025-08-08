// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traxes/bloc/feature/bill/bill.bloc.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/customer.card.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/widget/image.picker.dart';
import 'package:traxes/model/bill/bill.model.dart';

class BillsScreen extends StatefulWidget {
  final String? customerName;
  final String? address;
  final String? customerId;
  const BillsScreen(
      {super.key, this.customerName, this.address, this.customerId});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> with TickerProviderStateMixin {
  File? imageBill;
  File? imageBill2;
  File? imageBill3;
  String? img64;
  String? img64Bill2;
  String? img64Bill3;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

   Future<void> showImagePickerOptions(Function(ImageSource) onImageSelected) async {
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

  void getImageBill() async {
  showImagePickerOptions((ImageSource source) async {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imageBill = File(pickedFile.path);
        final bytes = imageBill!.readAsBytesSync();
        img64 = base64Encode(bytes);
      } else if (pickedFile == null) {
        EasyLoading.showError("Fotonya mana?",
            duration: const Duration(seconds: 3));
      }
    });
  });
  }

  void getImageBill2() async {
   showImagePickerOptions((ImageSource source) async {
     XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imageBill2 = File(pickedFile.path);
        final bytes = imageBill2!.readAsBytesSync();
        img64Bill2 = base64Encode(bytes);
      } else if (pickedFile == null) {
        EasyLoading.showError("Fotonya mana?",
            duration: const Duration(seconds: 3));
      }
    });
   } );
  }

  void getImageBill3() async {
   showImagePickerOptions((ImageSource source) async {
     XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imageBill3 = File(pickedFile.path);
        final bytes = imageBill3!.readAsBytesSync();
        img64Bill3 = base64Encode(bytes);
      } else if (pickedFile == null) {
        EasyLoading.showError("Fotonya mana?",
            duration: const Duration(seconds: 3));
      }
    });
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: Text("Struk", style: standarWhiteTextB,)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomerInfoCard(
                    customerId: widget.customerId.toString(),
                    customerName: widget.customerName.toString(),
                    address: widget.address.toString(),
                  ),
              const SizedBox(height: 40),
              Text(
                "Masukkan 3 foto struk",
                style: standarBlackTextB,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomImagePicker(imageFile: imageBill, label: "Foto 1", onTap: getImageBill),
                  CustomImagePicker(imageFile: imageBill2, label: "Foto 2", onTap: getImageBill2),
                  CustomImagePicker(imageFile: imageBill3, label: "Foto 3", onTap: getImageBill3),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF661C63),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () async {
                    var connectivityResult =
                        await Connectivity().checkConnectivity();

                    if (img64 == null) {
                      EasyLoading.showError(
                        "Minimal 1 foto struk harus diisi",
                        duration: const Duration(seconds: 3),
                      );
                    } else if (connectivityResult
                        .contains(ConnectivityResult.none)) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
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
                                child: Text('OK', style: smallBlackText),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      CoolAlert.show(
                          confirmBtnColor: const Color(0xFF661C63),
                          confirmBtnText: "Input Struk",
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
                            var data = BillModel(
                              bill: img64,
                              bill2: img64Bill2,
                              bill3: img64Bill3,
                              customerId: widget.customerId,
                            );
                            context
                                .read<BillBloc>()
                                .sendBill(data, context);
                          });
                    }
                  },
                  child: Text(
                    "Update Struk",
                    style: smallWhiteText,
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
