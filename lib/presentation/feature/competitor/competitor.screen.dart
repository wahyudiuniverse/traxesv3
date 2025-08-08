
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:traxes/bloc/feature/competitor/competitor.bloc.dart';
import 'package:traxes/constant/widget/customer.card.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/model/competitor/competitor.model.dart';

class CompetitorScreen extends StatefulWidget {
  final String? customerName;
  final String? address;
  final String? customerId;

  const CompetitorScreen(
      {super.key, this.customerName, this.address, this.customerId});

  @override
  State<CompetitorScreen> createState() => _CompetitorScreenState();
}

class _CompetitorScreenState extends State<CompetitorScreen> {
  File? imageCompetitor;
  File? imageCompetitor2;
  String? img64;
  String? img64_2;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getImageCompetitor() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imageCompetitor = File(pickedFile.path);
        final bytes = imageCompetitor!.readAsBytesSync();
        img64 = base64Encode(bytes);
      } else {
        EasyLoading.showError("Please take a photo of the product",
            duration: const Duration(seconds: 3));
      }
    });
  }

  void getImageCompetitor2() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imageCompetitor2 = File(pickedFile.path);
        final bytes = imageCompetitor2!.readAsBytesSync();
        img64_2 = base64Encode(bytes);
      } else {
        EasyLoading.showError("Please take a photo of the product",
            duration: const Duration(seconds: 3));
      }
    });
  }

  final materialNameController = TextEditingController();
  final qtyController = TextEditingController();
  final normalPriceController = TextEditingController();
  final promoPriceController = TextEditingController();
  final promoDateController = TextEditingController();
  final endPromoDateController = TextEditingController();
  final detailPromoController = TextEditingController();
  final omzetController = TextEditingController();

  @override 
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    materialNameController.dispose();
    qtyController.dispose();
    normalPriceController.dispose();
    promoPriceController.dispose();
    promoDateController.dispose();
    endPromoDateController.dispose();
    detailPromoController.dispose();
    omzetController.dispose();
  }

  DateTime initialDate = DateTime(2023, 1, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  GradientAppBar(
        title: Text(
          "Competitor",
          style: standarWhiteTextB,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Customer Info Card
                   CustomerInfoCard(
                        customerId: widget.customerId.toString(),
                        customerName: widget.customerName.toString(),
                        address: widget.address.toString(),
                       ),
                  const SizedBox(height: 20),
                  
                  // Section Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "* Product Details",
                      style: smallColorFontGrey.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Material Name
                  TextFormField(
                    controller: materialNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category, color: Color(0xFF1C4966)),
                      labelText: "Material Name",
                      labelStyle: smallColorFontGrey,
                      filled: true,
                      fillColor: Colors.grey[100],
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1C4966)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Quantity
                  TextFormField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.confirmation_number, color: Color(0xFF1C4966)),
                      labelText: "Quantity",
                      labelStyle: smallColorFontGrey,
                      filled: true,
                      fillColor: Colors.grey[100],
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1C4966)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Uncomment if validation is needed
                    // validator: (v) {
                    //   if (v!.isEmpty) {
                    //     return "This field is required";
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 15),

                  // Normal Price
                  TextFormField(
                    controller: normalPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money, color: Color(0xFF1C4966)),
                      labelText: "Normal Price",
                      labelStyle: smallColorFontGrey,
                      filled: true,
                      fillColor: Colors.grey[100],
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1C4966)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Section Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "* Promo Details",
                      style: smallColorFontGrey.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Promo Price
                  TextFormField(
                    controller: promoPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.price_check, color: Color(0xFF1C4966)),
                      labelText: "Promo Price",
                      labelStyle: smallColorFontGrey,
                      filled: true,
                      fillColor: Colors.grey[100],
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1C4966)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Promo Start Date
                  TextFormField(
                    controller: promoDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF1C4966)),
                      labelText: "Promo Start Date",
                      labelStyle: smallColorFontGrey,
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Color(0xFF1C4966)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1C4966)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now().add(const Duration(days: 1095)),
                      );

                      if (pickedDate != null) {
                        promoDateController.text =
                            DateFormat("yyyy-MM-dd").format(pickedDate);
                      }
                    },
                    // Uncomment if validation is needed
                    // validator: (v) {
                    //   if (v!.isEmpty) {
                    //     return "This field is required";
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 15),

                  // Promo End Date
                  TextFormField(
                    controller: endPromoDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF1C4966)),
                      labelText: "Promo End Date",
                      labelStyle: smallColorFontGrey,
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Color(0xFF1C4966)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1C4966)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 1095)),
                      );

                      if (pickedDate != null) {
                        endPromoDateController.text =
                            DateFormat("yyyy-MM-dd").format(pickedDate);
                      }
                    },
                    // Uncomment if validation is needed
                    // validator: (v) {
                    //   if (v!.isEmpty) {
                    //     return "This field is required";
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 15),

                  // Promo Details
                  TextFormField(
                    controller: detailPromoController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description, color: Color(0xFF1C4966)),
                      labelText: "Promo Description",
                      labelStyle: smallColorFontGrey,
                      filled: true,
                      fillColor: Colors.grey[100],
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1C4966)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Uncomment if validation is needed
                    // validator: (v) {
                    //   if (v!.isEmpty) {
                    //     return "This field is required";
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 15),

                  // Omzet
                  TextFormField(
                    controller: omzetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money, color: Color(0xFF1C4966)),
                      labelText: "Omzet",
                      labelStyle: smallColorFontGrey,
                      filled: true,
                      fillColor: Colors.grey[100],
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1C4966)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Uncomment if validation is needed
                    // validator: (v) {
                    //   if (v!.isEmpty) {
                    //     return "This field is required";
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 20),

                  // Image Pickers
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "* Promo Product Photos",
                      style: smallColorFontGrey.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Image Picker 1
                      Expanded(
                        child: GestureDetector(
                          onTap: getImageCompetitor,
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: imageCompetitor == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, size: 40, color: Color(0xFF1C4966)),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Photo 1",
                                        style: smallColorFontGrey,
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      imageCompetitor!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Image Picker 2
                      Expanded(
                        child: GestureDetector(
                          onTap: getImageCompetitor2,
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: imageCompetitor2 == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, size: 40, color: Color(0xFF1C4966)),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Photo 2",
                                        style: smallColorFontGrey,
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      imageCompetitor2!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var connectivityResult = await Connectivity().checkConnectivity();
                        if (imageCompetitor == null) {
                          EasyLoading.showError("Please provide one photo.",
                              duration: const Duration(seconds: 3));
                        } else if (connectivityResult.contains(ConnectivityResult.none)) {
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
                          CoolAlert.show(
                            confirmBtnColor: const Color(0xFF661C63),
                            confirmBtnText: "Add Competitor",
                            confirmBtnTextStyle: smallWhiteText,
                            cancelBtnText: "Cancel",
                            cancelBtnTextStyle: smallColorFontGrey,
                            backgroundColor: const Color(0xFF661C63),
                            animType: CoolAlertAnimType.slideInUp,
                            title:
                                "Are you sure you want to submit the competitor?",
                            titleTextStyle: standarBlackText,
                            context: context,
                            type: CoolAlertType.confirm,
                            onConfirmBtnTap: () {
                              if (formKey.currentState!.validate() &&
                                  imageCompetitor != null &&
                                  imageCompetitor2 != null) {
                                var data = CompetitorModel(
                                  customerId: widget.customerId,
                                  namaMaterial: materialNameController.text,
                                  qty: int.parse(
                                      qtyController.text.toString()),
                                  hargaNormal: int.parse(
                                      normalPriceController.text
                                          .toString()),
                                  hargaPromo: int.parse(
                                      promoPriceController.text.toString()),
                                  tanggalPromo: promoDateController.text,
                                  akhirPromo: endPromoDateController.text,
                                  keteranganPromo:
                                      detailPromoController.text,
                                  omzet: omzetController.text,
                                  foto1: img64,
                                  foto2: img64_2,
                                );

                                context
                                    .read<CompetitorBloc>()
                                    .submitCompetitor(data, context);
                                EasyLoading.show(status: 'Submitting...');
                              } else {
                                EasyLoading.showError("Please complete all required fields.",
                                    duration: const Duration(seconds: 3));
                              }
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: const Color(0xFF661C63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Submit Competitor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}