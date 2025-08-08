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
import 'package:traxes/bloc/feature/sku/sku.bloc.dart';
import 'package:traxes/constant/screen/success.order.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/model/sku/send.sku.model.dart';
import 'package:traxes/presentation/feature/sku/input_order/sku.search.screen.dart';

class InputSkuScreen extends StatefulWidget {
  final String? productId;
  final String? productName;
  final String? customerId;
  final String? customerName;
  final String? uomTotal;
  final String? price;
  final String? point;
  final String? volume;
  const InputSkuScreen(
      {super.key,
      this.customerId,
      this.productId,
      this.uomTotal,
      this.price,
      this.customerName,
      this.productName,
      this.point,
      this.volume});

  @override
  State<InputSkuScreen> createState() => _InputSkuScreenState();
}

class _InputSkuScreenState extends State<InputSkuScreen> {
  final materialController = TextEditingController();
  final priceController = TextEditingController();
  final totalOrderController = TextEditingController();
  final materialPrice = TextEditingController();
  final productController = TextEditingController();
  final search = TextEditingController();
  final materialNameController = TextEditingController();
  final totalPointController = TextEditingController();

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

  int totalPriceNumeric = 0;

  double totalPoint = 0;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getProductId() {
    widget.productId == null
        ? ""
        : productController.text = "${widget.productId}";
  }

  String formatToRupiah(int value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  void getProductName() {
    widget.productName == null
        ? ""
        : materialNameController.text = "${widget.productName}";
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text(
            "Buat Order/Sell out",
            style: standarWhiteTextB,
          ),
        ),
        body:SingleChildScrollView(
  child: Form(
    key: formKey,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section (Optional)
           Text(
            "Detail order",
            style: extraLargeBlackTextB
          ),
          const SizedBox(height: 20),

          // Product Code Field
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextFormField(
              onTap: () {
                Get.to(const SearchSku());
              },
              validator: (v) {
                if (v!.isEmpty) {
                  return "Please select a product first";
                } else {
                  return null;
                }
              },
              readOnly: true,
              controller: productController,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search),
                labelText: "Cari produk",
                labelStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[200],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF661C63),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search for product here",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
              ),
            ),
          ),

          // Material Name Field
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextFormField(
              readOnly: true,
              keyboardType: TextInputType.number,
              controller: materialNameController,
              decoration: InputDecoration(
                labelText: "Nama material/sku",
                labelStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[200],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF661C63),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: "Material/SKU Name",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
              ),
            ),
          ),

          // Quantity Field
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: totalOrderController,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v!.isEmpty) {
                  return "Please input quantity first";
                } else {
                  return null;
                }
              },
              onChanged: (v) {
                setState(() {
                  if (v.isEmpty) {
                    priceController.text = '0';
                    totalPointController.text = '0';
                  } else {
                    totalPriceNumeric = int.parse(widget.uomTotal.toString()) *
                        int.parse(v.toString());
                    priceController.text = formatToRupiah(totalPriceNumeric);

                    double points = double.parse(widget.point.toString());
                    double volumes = double.parse(widget.volume.toString());
                    double val = double.parse(v);

                    totalPoint = points * volumes * val;

                    totalPointController.text =
                        totalPoint.toStringAsFixed(2);
                  }
                });
              },
              decoration: InputDecoration(
                labelText: "Qty",
                labelStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[200],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF661C63),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: "Enter quantity",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
              ),
            ),
          ),

          // Total Price Field
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: "Total harga",
                labelStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[200],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF661C63),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: "Calculated automatically",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
              ),
            ),
          ),

          // Total Points Field
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextFormField(
              controller: totalPointController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Total Points",
                labelStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[200],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF661C63),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: "Calculated automatically",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 16),
              ),
            ),
          ),

          // Submit Button
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CustomButton(
              width: double.infinity,
              borderRadius: BorderRadius.circular(12),
              onPressed: () async {
                var connectivityResult =
                    await Connectivity().checkConnectivity();

                if (connectivityResult.contains(ConnectivityResult.none)) {
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
                              child: Text('OK', style: smallBlackText),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  if (formKey.currentState!.validate()) {
                    await CoolAlert.show(
                      confirmBtnColor: const Color(0xFF661C63),
                      confirmBtnText: "Place Order Now",
                      confirmBtnTextStyle: smallWhiteText,
                      cancelBtnText: "Go Back",
                      cancelBtnTextStyle: smallColorFontGrey,
                      backgroundColor: const Color(0xFF661C63),
                      animType: CoolAlertAnimType.slideInUp,
                      title: "Is your order quantity correct?",
                      titleTextStyle: standarBlackText,
                      context: context,
                      type: CoolAlertType.confirm,
                      onConfirmBtnTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var empId = prefs.getString("empid");
                        var totalPriceString = priceController.text
                            .replaceAll(RegExp(r'[^0-9]'), '');
                        var data = SendSkuModel(
                            employeeId: empId,
                            customerId: widget.customerId,
                            materialId: productController.text,
                            qty: totalOrderController.text,
                            price: int.parse(widget.price.toString()),
                            total: int.parse(totalPriceString));
                        context.read<SkuBloc>().sendSku(
                            formData: data,
                            context: context,
                            onSuccess: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderSuccessScreen(
                                    productId: productController.text,
                                    productName: materialNameController.text,
                                    quantity: totalOrderController.text,
                                    price: widget.price.toString(),
                                    total: totalPriceString,
                                  ),
                                ),
                              );
                            });
                      },
                    );
                  }
                }
              },
              child: Text("Input penjualan", style: smallWhiteText),
            ),
          ),
        ],
      ),
    ),
  ),
));
}
}
