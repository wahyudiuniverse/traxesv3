import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/stock_product/input_stock/stock.product.screen.dart';

class StockMainScreen extends StatefulWidget {
  const StockMainScreen({super.key});

  @override
  State<StockMainScreen> createState() => _StockMainScreenState();
}

class _StockMainScreenState extends State<StockMainScreen> {
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
          "Stock Screen",
          style: standarWhiteTextB,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Button for "Isi Sell-out"
              Padding(
                padding: const EdgeInsets.only(bottom: 55, top: 110),
                child: GestureDetector(
                  onTap: () {
                    Get.to(StockProductScreen(
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
                                "Isi Stock",
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
                  prefs.setInt("check_stock", 1);
                  await EasyLoading.showSuccess(
                      "Pengajuan tidak isi stock disetujui",
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
                            Text("Tidak isi stock",
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