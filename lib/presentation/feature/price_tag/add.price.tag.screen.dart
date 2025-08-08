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
import 'package:traxes/bloc/feature/price_tag/price.tag.bloc.dart';
import 'package:traxes/bloc/feature/skupro/skupro.bloc.dart';
import 'package:traxes/bloc/feature/skupro/skupro.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/model/price_tag/price.tag.model.dart';

class AddPriceTagScreen extends StatefulWidget {
  final String? customerId;
  const AddPriceTagScreen({super.key, this.customerId});

  @override
  State<AddPriceTagScreen> createState() => _AddPriceTagScreenState();
}

class _AddPriceTagScreenState extends State<AddPriceTagScreen> {
  final materialController = TextEditingController();
  final priceController = TextEditingController();
  final materialPrice = TextEditingController();
  final productController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? imagePriceTag;
  String? selectOrder;
  String? img64;

  void getImageDisplay() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imagePriceTag = File(pickedFile.path);
        final bytes = imagePriceTag!.readAsBytesSync();
        img64 = base64Encode(bytes);
      } else if (pickedFile == null) {
        EasyLoading.showError("Fotonya mana?",
            duration: const Duration(seconds: 3));
      }
    });
  }

  void getOrder() async {
    context.read<SkuProBloc>().loadLocalSku();
  }

  void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
               Get.back();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkConnectivityAndNavigate();
    getOrder();
  }

  @override
  void dispose() {
    super.dispose();
    materialController.dispose();
    priceController.dispose();
    materialPrice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Price Tag",
          style: standarWhiteTextB,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C4966),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Input Price Tag",
                    style: largeBlackTextB,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: BlocBuilder<SkuProBloc, SkuProState>(
                      builder: (context, stateSku) {
                    if (stateSku is LoadLocalSku) {
                      return Column(
                        children: [
                          DropdownButtonFormField(
                            hint: Text(
                              "Pilih produk",
                              style: smallBlackText,
                            ),
                            items: stateSku.data
                                .map((e) => DropdownMenuItem(
                                      value: e.kodeSku,
                                      child: Text(e.namaMaterial.toString()),
                                    ))
                                .toList(),
                            onChanged: ((value) {
                              setState(() {
                                selectOrder = value.toString();
                                productController.text = selectOrder.toString();
                              });
                            }),
                            value: selectOrder,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: TextFormField(
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Pilih Produk terlebih dahulu";
                                } else {
                                  return null;
                                }
                              },
                              readOnly: true,
                              controller: productController,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF661C63), width: 2)),
                                  hintText: "Produk",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Input quantity terlebih dahulu";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF661C63), width: 2)),
                                  hintText: "Harga",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: Get.width / 2.2,
                            height: 160,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: Colors.black26),
                                borderRadius: BorderRadius.circular(15)),
                            child: InkWell(
                              onTap: () {
                                getImageDisplay();
                              },
                              child: imagePriceTag == null
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
                                          "Foto price tag",
                                          style: smallColorFontGrey,
                                        )
                                      ],
                                    )
                                  : Image.file(
                                      imagePriceTag!,
                                      width: 170,
                                      height: 170,
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1C4966),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () async {
                                var connectivityResult = await Connectivity().checkConnectivity();
                                if(imagePriceTag == null) {
                                  EasyLoading.showError(
                                            "Fotonya mana? :(",
                                            duration:
                                                const Duration(seconds: 3));
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
                                }
                                CoolAlert.show(
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Input Price Tag",
                                    confirmBtnTextStyle: smallWhiteText,
                                    cancelBtnText: "Kembali",
                                    cancelBtnTextStyle: smallColorFontGrey,
                                    backgroundColor: const Color(0xFF661C63),
                                    animType: CoolAlertAnimType.slideInUp,
                                    title:
                                        "Apakah sudah sesuai dengan jumlah yang kamu order ?",
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    onConfirmBtnTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance(); 
                                    String? empId = prefs.getString("empid").toString();

                                      if (formKey.currentState!.validate() &&
                                          imagePriceTag != null) {
                                        var data = PriceTagModel(
                                            employeeId: empId,
                                            customerId: widget.customerId,
                                            price: int.parse(priceController
                                                .text
                                                .toString()),
                                            materialId: productController.text,
                                            foto: img64);
                                        context
                                            .read<PriceTagBloc>()
                                            .sendPriceTag(data, context);
                                      } else if (imagePriceTag == null) {
                                        
                                      }
                                    }).then((value) => {
                                      Navigator.pop(context),
                                      setState(() {
                                        context
                                            .read<PriceTagBloc>()
                                            .getPriceTag(context: context);
                                      })
                                    });
                              },
                              child: const Text("Input price tag")),
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}