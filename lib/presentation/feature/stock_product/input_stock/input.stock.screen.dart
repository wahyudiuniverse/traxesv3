// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/stock/stock.bloc.dart';
import 'package:traxes/constant/screen/success.stock.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/sharedprefs.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/model/stock_update/stock.update.model.dart';
import 'package:traxes/presentation/feature/stock_product/input_stock/stock.search.screen.dart';

class InputStockScreen extends StatefulWidget {
  final String? productId;
  final String? productName;
  final String? customerId;
  final String? customerName;
  final String? uomTotal;
  const InputStockScreen(
      {super.key,
      this.customerId,
      this.productId,
      this.uomTotal,
      this.customerName,
      this.productName});

  @override
  State<InputStockScreen> createState() => _InputStockScreenState();
}

class _InputStockScreenState extends State<InputStockScreen> {
  final materialController = TextEditingController();
  final productController = TextEditingController();
  final quantityController = TextEditingController();
  final search = TextEditingController();
  final materialNameController = TextEditingController();
  final dateController = TextEditingController();

  bool isListViewVisible = true;

  String? customerName;

  String? name;
  String? getLocation;
  Position? position;
  Placemark? placemark;
  String? customerId;
  String? address;

  String? productId;

  String? totalPrice;

  String? uomTotal;

  String? selectOrder;

  String? totalOrder;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getProductId() {
    widget.productId == null
        ? ""
        : productController.text = "${widget.productId}";
  }

  void getProductName() {
    widget.productName == null
        ? ""
        : materialNameController.text = "${widget.productName}";
  }

  void getNama() async {
    name = await LocalStorage.getString("name");
    setState(() {});
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

  void getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();
    await GetGeolocator()
        .getAddressLatLang(position!)
        .then((value) => {placemark = value});
  }

  @override
  void initState() {
    super.initState();
    getNama();
    getCurrentLocation();
    getProductId();
    getAddress();
    getCustomerName();
    getCustomerId();
    getProductName();
    uomTotal = widget.uomTotal;
    productId = widget.productId;
    widget.customerId.toString();
    widget.customerName.toString();
    address;
  }

  @override
  void dispose() {
    super.dispose();
    search.dispose();
    materialController.dispose();
    productController.dispose();
    dateController.dispose();
    materialNameController.dispose();
    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text(
            "Buat Stock/Sell in",
            style: standarWhiteTextB,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 25, top: 10, bottom: 5),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: TextFormField(
                          onTap: () {
                            Get.to(const SearchStock());
                          },
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
                              fillColor: const Color(0xFFD3D3D3),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF661C63), width: 1)),
                              hintText: "Cari produk disini",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          controller: materialNameController,
                          decoration: InputDecoration(
                              fillColor: const Color(0xFF1C4966),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF661C63), width: 1)),
                              hintText: "Nama Material/Sku",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Input renceng terlebih dahulu";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF661C63), width: 1)),
                              hintText: "Quantity",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 1095)),
                            );

                            if (pickedDate != null) {
                              dateController.text =
                                  DateFormat("yyyy-MM-dd").format(pickedDate);
                            }
                          },
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "This field is required";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFF1C4966)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "Pilih tanggal kadaluarsa",
                            hintStyle: smallColorFontGrey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: CustomButton(
                              borderRadius: BorderRadius.circular(8),
                              width: double.infinity,
                              onPressed: () async {
                                var connectivityResult =
                                    await Connectivity().checkConnectivity();
                                if (connectivityResult
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
                                                Get.back();
                                              },
                                              child: Text('OK',
                                                  style: smallBlackText),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  if (formKey.currentState!.validate()) {
                                    CoolAlert.show(
                                        confirmBtnColor:
                                            const Color(0xFF661C63),
                                        confirmBtnText: "Buat order sekarang",
                                        confirmBtnTextStyle: smallWhiteText,
                                        cancelBtnText: "Kembali",
                                        cancelBtnTextStyle: smallColorFontGrey,
                                        backgroundColor:
                                            const Color(0xFF661C63),
                                        animType: CoolAlertAnimType.slideInUp,
                                        title:
                                            "Apakah sudah sesuai dengan jumlah yang kamu order ?",
                                        titleTextStyle: standarBlackText,
                                        context: context,
                                        type: CoolAlertType.confirm,
                                        onConfirmBtnTap: () async {
                                          String cdate =
                                              DateFormat("yyyy-MM-dd")
                                                  .format(DateTime.now());

                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var empId = prefs.getString("empid");
                                          var data = UpdateStockModel(
                                              customerId: widget.customerId,
                                              materialId:
                                                  productController.text,
                                              employeeId: empId,
                                              stockDate: cdate,
                                              expDate: dateController.text,
                                              stockQty:
                                                  quantityController.text);
                                          context
                                              .read<StockBloc>()
                                              .insertMaterial(
                                                  formData: data,
                                                  context: context,
                                                  onSuccess: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            StockSuccessScreen(
                                                          productId:
                                                              productController
                                                                  .text,
                                                          productName:
                                                              materialNameController
                                                                  .text,
                                                          quantity:
                                                              quantityController
                                                                  .text,
                                                          expDate:
                                                              dateController
                                                                  .text,
                                                        ),
                                                      ),
                                                    );
                                                  });
                                        });
                                  }
                                }
                              },
                              child: Text(
                                "Input stock",
                                style: smallWhiteText,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
