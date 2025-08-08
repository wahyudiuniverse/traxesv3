// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomerInfoCard extends StatelessWidget {
  final String customerName;
  final String address;
  final String customerId;

  const CustomerInfoCard({super.key, 
    required this.customerName,
    required this.address,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF661C63),
              Color(0xFF1C4966),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and Name
            Row(
              children: [
                Image.asset(
                  "assets/images/add-toko-new-removebg-preview.png",
                  color: Colors.white,
                  width: 60,
                  height: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    customerName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Address
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Customer ID
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  customerId.isEmpty ? "N/A" : customerId,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
