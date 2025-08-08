import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traxes/constant/screen/verify,mbd.card.dart';
import 'package:traxes/constant/text.style.dart';

class ResultFilterMbd extends StatefulWidget {
  final  String? startDate;
  final String? endDate;
  final String? statusDisplay;
  final String? verifyStatus;
  const ResultFilterMbd
  ({super.key,
  required this.startDate,
  required this.endDate,
  required this.statusDisplay,
  required this.verifyStatus  
  });

  @override
  State<ResultFilterMbd> createState() => _ResultFilterMbdState();
}

class _ResultFilterMbdState extends State<ResultFilterMbd> {
  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd MMMM yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Verifikasi MBD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          //  Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     'Hasil Filter',
          //     style: largeBlackText
          //   ),
          // ),
          Container(
            color: const Color(0xFF1C4966),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Text(
             "${formatDate(widget.startDate.toString())}" "  •  " "${formatDate(widget.endDate.toString())}" ,
              style: largeWhiteText
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children:  [
                MbdCard(
                  outletName: widget.startDate.toString(),
                  outletId: '',
                  employeeId: '',
                  photoStatus: '',
                  photoVerify: '',
                  completeSku: '',
                  uploadDate: '',
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       TextButton(
      //         onPressed: () {},
      //         child: const Text('SORT'),
      //       ),
      //       TextButton(
      //         onPressed: () {},
      //         child: const Text('FILTER'),
      //       ),
      //       TextButton(
      //         onPressed: () {},
      //         child: const Text('CHANGE DATE'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

