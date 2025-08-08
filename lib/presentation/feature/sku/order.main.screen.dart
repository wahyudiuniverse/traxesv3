import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/sku/input_order/order.screen.dart';

class OrderMainScreen extends StatefulWidget {
  const OrderMainScreen({super.key});

  @override
  State<OrderMainScreen> createState() => _OrderMainScreenState();
}

class _OrderMainScreenState extends State<OrderMainScreen> {
  String? customerName;
  String? nik;
  String? customerId;
  String? address;
  String? projectId;
  bool isButtonClicked = false; 

  void callNik() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nik = prefs.getString("empid").toString();
    });
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

  @override
  void initState() {
    super.initState();
    getCustomerName();
    getCustomerId();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Order Screen",
          style: standarWhiteTextB,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 55, top: 110),
                child: GestureDetector(
                  onTap: () {
                    Get.to(OrderScreen(
                      customerName: customerName,
                      customerId: customerId,
                      address: address,
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF50D5B7), // Start color (vibrant purple)
                              Color(0xFF067D68), // End color
                            ],
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shop_2,
                                size: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                "Isi Penjualan",
                                style: standarWhiteText,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Button for "Tidak ada penjualan"
              GestureDetector(
                onTap: () async {
                  // Set the button clicked status to true
                  setState(() {
                    isButtonClicked = true;
                  });
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt("check_order", 1);
                  await EasyLoading.showSuccess(
                      "Anda mengajukan no sell out hari ini",
                      duration: const Duration(seconds: 3));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE65758), // Start color (vibrant purple)
                            Color(0xFF771D32), // End color
                          ],
                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.close,
                              size: 60,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text("Tidak ada penjualan",
                                style: standarWhiteText)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Show EasyLoading if the button is not clicked
            ],
          ),
        ),
      ),
    );
  }
}