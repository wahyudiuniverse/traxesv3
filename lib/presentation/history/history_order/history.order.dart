// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/history/history_order/history.order.bloc.dart';
import 'package:traxes/bloc/history/history_order/history.order.state.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/widget/rupiah.converter.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/model/history_order/history.order.date.request.model.dart';
import 'package:traxes/model/history_order/history.order.model.dart';
import 'package:traxes/presentation/dashboard/dashboard.screen.dart';

class HistoryOrderScreen extends StatefulWidget {
  final String? customerName;
  final String? address;
  final String? customerId;
  const HistoryOrderScreen(
      {super.key, this.customerName, this.address, this.customerId});

  @override
  State<HistoryOrderScreen> createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  final dateController = TextEditingController();
  final datesController = TextEditingController();
  String? dateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());

  void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
        Get.offAll(const DashboardScreen());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<HistoryOrderBloc>().getHistoryOrder(context: context);
    checkConnectivityAndNavigate();
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
  }

  Future<void> generateAndDownloadExcel(
      DateTime dateTime, List<DataHistoryOrder> data) async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName('A1').setText('Material');
    sheet.getRangeByName('B1').setText('Customer Name');
    sheet.getRangeByName('C1').setText('Order Date');
    sheet.getRangeByName('D1').setText('Qty');
    sheet.getRangeByName('E1').setText('Poin');
    sheet.getRangeByName('F1').setText('Price');
    sheet.getRangeByName('G1').setText('Total');
    sheet.getRangeByName('H1').setText('Total Poin');

    for (int i = 0; i < data.length; i++) {
      final DataHistoryOrder historyOrder = data[i];
      sheet
          .getRangeByName('A${i + 2}')
          .setText(historyOrder.namaMaterial.toString());
      sheet
          .getRangeByName('B${i + 2}')
          .setText(historyOrder.customerName.toString());
      sheet
          .getRangeByName('C${i + 2}')
          .setText(historyOrder.orderDate.toString());
      sheet.getRangeByName('D${i + 2}').setText(historyOrder.qty.toString());
      sheet.getRangeByName('E${i + 2}').setText(historyOrder.poin.toString());
      sheet.getRangeByName('F${i + 2}').setText(historyOrder.price.toString());
      sheet.getRangeByName('G${i + 2}').setText(historyOrder.total.toString());
      sheet.getRangeByName('H${i + 2}').setText(
          "${int.parse(historyOrder.qty.toString()) * int.parse(historyOrder.poin.toString())}");
    }

    // Save the workbook
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Get the directory for saving the file
    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path =
        '$dir/history_orders_${DateFormat('yyyyMMdd').format(dateTime)}.xlsx';
    final File file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Berhasil di download', style: standarBlackTextB),
        content: Text('File excel tersimpan di $path'),
        actions: [
          TextButton(
            onPressed: () async {
              await OpenFile.open(path);
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Lihat dokumen'),
          ),
        ],
      ),
    );
  }

 Widget buildDateField(String label, TextEditingController controller, {DateTime? lastDate}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1C4966),
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          DateTime? initialDate = DateTime.now();
          DateTime? firstDate = DateTime(2023);
          DateTime? lastDate = DateTime.now().add(const Duration(days: 1095));

          if (controller == datesController && dateController.text.isNotEmpty) {
            DateTime firstPickedDate = DateFormat("yyyy-MM-dd").parse(dateController.text);
            initialDate = firstPickedDate.add(const Duration(days: 1));
            firstDate = firstPickedDate.add(const Duration(days: 1));
            lastDate = firstPickedDate.add(const Duration(days: 7)); 
          }

          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
          );

          if (pickedDate != null) {
            setState(() {
              controller.text = DateFormat("yyyy-MM-dd").format(pickedDate);
              if (kDebugMode) {
                print('${controller == dateController ? "Start" : "End"} Date: ${controller.text}');
              }
            });
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 15,
          ),
          suffixIcon:
              const Icon(Icons.calendar_today, color: Color(0xFF661C63)),
          hintText: "Pilih $label",
          hintStyle: standarColorFontGrey,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF661C63), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600]!, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(115.0),
        child: Stack(
          children: [
            GradientAppBar(
              title:
                  Text("Riwayat sell-out/penjualan", style: standarWhiteTextB),
            ),
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Pilih periode Order/Sellout", style: standarBlackTextB),
                const SizedBox(height: 20),
                buildDateField("Tanggal mulai", dateController),
                const SizedBox(height: 20),
                buildDateField("Tanggal akhir", datesController, lastDate: dateController.text.isNotEmpty ? DateFormat("yyyy-MM-dd").parse(dateController.text).add(const Duration(days: 7)) : null),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var empId = prefs.getString("empid");

                      var data = HistoryOrderDateRequestModel(
                        employeeId: empId,
                        firstDate: dateController.text,
                        lastDate: datesController.text
                      );
                      DateTime? selectedDate = DateFormat("yyyy-MM-dd").parse(dateController.text);
                      
                      await context.read<HistoryOrderBloc>().sendHistoryOrder(formData: data, context: context);
                      
                      context.read<HistoryOrderBloc>().getHistoryOrder(
                        selectedDate: selectedDate,
                        formData: data,
                        context: context
                      );
                      
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Text("Pilih periode", style: standarWhiteText),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  },
  child: Padding(
    padding:  EdgeInsets.only(right: dateController.text.isEmpty && datesController.text.isEmpty ? 150 : 80),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateController.text.isEmpty && datesController.text.isEmpty
                  ? "Pilih tanggal"
                  : "${dateController.text} s/d ${datesController.text}",
              style: standarColorFontGrey,
            ),
            const Icon(Icons.calendar_today, color: Color(0xFF661C63)),
          ],
        ),
      ),
    ),
  ),
)
),
          ],
        ),
      ),
      body: SafeArea(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<HistoryOrderBloc, HistoryOrderState>(
            builder: (context, stateHistory) {
              if (stateHistory is HistoryOrderLoaded) {
                if (stateHistory.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Lottie.network(
                          'https://lottie.host/7d5433bd-f719-4ab4-8e14-542eb8fc4301/HryEUdMZ0f.json',
                          frameRate: FrameRate.max,
                          width: 250,
                          height: 250,
                          fit: BoxFit.contain,
                          repeat: true,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "No Sales Data",
                          style: largeBlackText.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Please check again later.",
                          style: smallBlackText,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            DateTime selectedDate = DateFormat("yyyy-MM-dd")
                                .parse(dateController.text);
                            await generateAndDownloadExcel(
                                selectedDate, stateHistory.data);
                          },
                          icon: const Icon(Icons.download),
                          label: const Text("Download Excel"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        itemCount: stateHistory.data.length,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          var historyOrder = stateHistory.data[i];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      historyOrder.namaMaterial.toString(),
                                      style: standarBlackTextB.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Toko: ${historyOrder.customerName.toString()}",
                                      style: standarBlackText,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Date: ${historyOrder.orderDate.toString()}",
                                      style: smallBlackText.copyWith(
                                          color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      height: 20,
                                      thickness: 1,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Qty: ${historyOrder.qty.toString()}",
                                              style: smallBlackText,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Poin: ${historyOrder.poin.toString()}",
                                              style: smallBlackText,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Harga: ${RupiahConverter().formatToRupiah(int.parse(historyOrder.price.toString()))}",
                                              style: smallBlackTextB,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Total: ${RupiahConverter().formatToRupiah(int.parse(historyOrder.total.toString()))}",
                                              style: smallBlackTextB,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Total Points: ${historyOrder.totalPoin}",
                                              style: smallBlackText,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    ),
  ),
)
);
  }
}
