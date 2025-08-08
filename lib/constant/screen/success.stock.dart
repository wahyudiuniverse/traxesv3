
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/stock_product/input_stock/stock.product.screen.dart';
import 'package:traxes/presentation/user/activity.screen.dart';

class StockSuccessScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String quantity;
  final String expDate;

  const StockSuccessScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.expDate,
  });

  @override
  State<StockSuccessScreen> createState() => _StockSuccessScreenState();
}

class _StockSuccessScreenState extends State<StockSuccessScreen> {

  String? customerId;
  String? customerName;
  String? address;

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
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80.0,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Berhasil input stok',
                      style: extraLargeBlackTextB
                    ),
                    const SizedBox(height: 20.0),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 20.0),
                    buildInfoRow('ID Produk:', widget.productId),
                    const SizedBox(height: 10.0),
                    buildInfoRow('Nama produk:', widget.productName),
                    const SizedBox(height: 10.0),
                    buildInfoRow('Jumlah:', widget.quantity),
                    const SizedBox(height: 10.0),
                    buildInfoRow('Tanggal expired:', widget.expDate),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
             
               
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF661C63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                ),
                onPressed: () {
                 Get.off(StockProductScreen(
                  customerId: customerId,
                  customerName: customerName,
                  address: address,
                 )); // Go back to the previous screen
                },
                child: const Text(
                  'Kembali ke menu stock',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              const SizedBox(height: 10.0),
               ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF661C63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                ),
                onPressed: () {
                 Get.offAll(const EmployeeScreen()); // Go back to the previous screen
                },
                child: const Text(
                  'Kembali ke halaman utama',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: largeColorFontGrey
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: standarBlackTextB,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
