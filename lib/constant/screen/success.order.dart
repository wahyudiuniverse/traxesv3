// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/sku/input_order/order.screen.dart';
import 'package:traxes/presentation/user/activity.screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String quantity;
  final String price;
  final String total;

  const OrderSuccessScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {

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
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Berhasil input sellout',
                      style: extraLargeBlackTextB
                    ),
                    SizedBox(height: 20.0),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: 20.0),
                    buildInfoRow('ID Produk:', widget.productId),
                    SizedBox(height: 10.0),
                    buildInfoRow('Nama produk:', widget.productName),
                    SizedBox(height: 10.0),
                    buildInfoRow('Jumlah:', widget.quantity),
                    SizedBox(height: 10.0),
                    buildInfoRow('Harga barang:', widget.price),
                    SizedBox(height: 10.0),
                    buildInfoRow('Total:', widget.total),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
             
               
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF661C63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                ),
                onPressed: () {
                 Get.off(OrderScreen(
                  customerId: customerId,
                  customerName: customerName,
                  address: address,
                 )); // Go back to the previous screen
                },
                child: Text(
                  'Kembali ke menu order',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              SizedBox(height: 10.0),
               ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF661C63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                ),
                onPressed: () {
                 Get.offAll(EmployeeScreen()); // Go back to the previous screen
                },
                child: Text(
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
        SizedBox(width: 10.0),
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
