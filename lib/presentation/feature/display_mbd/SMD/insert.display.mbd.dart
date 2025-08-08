// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/display_mbd/display.mbd.bloc.dart';
import 'package:traxes/constant/screen/success.mbd.display.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';

import 'package:image/image.dart' as img;
import 'package:traxes/model/display_mbd/insert/insert.mbd.display.model.dart';

class InsertDisplayMbdScreen extends StatefulWidget {
  final String? customerName;
  final String? customerId;
  final String? address;
  const InsertDisplayMbdScreen(
      {super.key, this.customerName, this.customerId, this.address});

  @override
  State<InsertDisplayMbdScreen> createState() => _InsertDisplayMbdScreenState();
}

class _InsertDisplayMbdScreenState extends State<InsertDisplayMbdScreen> {
  DateTime? selectedDate;
  Uint8List? imgBytes;
  Uint8List? watermarkedImgBytes;
  XFile? imageFile;
  String enteredText = "";
  String? selectedValue;

  final keteranganController = TextEditingController();

  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());

  final Map<int, String> statusDisplay = {1: 'MBD Rent', 2: 'MBD Free'};

  final List<int> displayValues = [1, 2];

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (pickedImage != null) {
      final t = await pickedImage.readAsBytes();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var nip = prefs.getString("empid");
      final watermarkedImgBytes = await ImageWatermark.addTextWatermark(
        imgBytes: t,
        watermarkText: " $nip \n $currentDate \n $tdata",
        font: img.arial_14,
        color: Colors.white,
        dstX: 10,
        dstY: 220,
      );
      setState(() {
        imgBytes = Uint8List.fromList(watermarkedImgBytes);
      });
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1C4966), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1C4966), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          'Upload display MBD',
          style: standarWhiteTextB,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1C4966), Color(0xFF661C63)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                      image: imgBytes != null
                          ? DecorationImage(
                              image: MemoryImage(imgBytes!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imgBytes == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                color: Colors.white70,
                                size: 60,
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Sentuh untuk mengupload foto",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
             
              const SizedBox(height: 30),
              Card(
                child: DropdownButtonFormField2<int>(
                  style: smallBlueText,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.shop_two),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    border: InputBorder.none,
                  ),
                  hint: Text('Pilih jenis MBD', style: standarBlueTextB),
                  items: displayValues.map((item) {
                    return DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                        statusDisplay[item]!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih Transport';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value.toString();
                    });
                  },
                  onSaved: (value) {
                    selectedValue = value.toString();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () async {
                    var connectivityResult =
                        await Connectivity().checkConnectivity();

                    if (imgBytes == null) {
                      EasyLoading.showError("Masukkan foto terlebih dahulu",
                          duration: const Duration(seconds: 3));
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
                                  child: Text('OK', style: smallBlackText),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          onConfirmBtnTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var projectId = prefs.getString("project_id");
                            String base64 = base64Encode(imgBytes!);

                            var data = InsertMbdDisplayModel(
                                customerId: widget.customerId.toString(),
                                projectId: projectId.toString(),
                                tanggalDisplay: selectedDate.toString(),
                                fotoDisplay: base64.toString(),
                                ketDisplay: keteranganController.text,
                                statusDisplay: int.tryParse(selectedValue.toString())
                                );
                            context.read<DisplayMbdBloc>().sendMbdDisplay(
                                formData: data,
                                context: context,
                                onSuccess: () {
                                  Get.off(const SuccessMbdScreen());
                                });
                          });
                    }
                  },
                  borderRadius: BorderRadius.circular(15),
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: const Color(0xFF1C4966),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   padding: const EdgeInsets.symmetric(vertical: 16),
                  // ),
                  child: Text('Submit', style: standarWhiteTextB),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
