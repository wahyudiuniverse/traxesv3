import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/stock/stock.bloc.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/model/stock_update/stock.update.model.dart';
import 'package:traxes/presentation/feature/stock_product/input_stock/stock.product.screen.dart';

class UpdateMaterialScreen extends StatefulWidget {
  final String? productName;
  final String? customerId;
  final String? materialId;
  const UpdateMaterialScreen(
      {super.key, this.productName, this.customerId, this.materialId});

  @override
  State<UpdateMaterialScreen> createState() => _UpdateMaterialScreenState();
}

class _UpdateMaterialScreenState extends State<UpdateMaterialScreen> {
  final productNameController = TextEditingController();
  final stockController = TextEditingController();
  final dateController = TextEditingController();
  final numberController = TextEditingController();
  final endStockController = TextEditingController();

  int counter = 0;
  int endStockCounter = 0;
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

  // String? dateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCustomerName();
    getCustomerId();
    getAddress();
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    stockController.dispose();
    dateController.dispose();
    numberController.dispose();
    endStockController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Perbarui Stock", style: standarWhiteTextB),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 8, left: 8, top: 15, bottom: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 25, bottom: 8),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "* Informasi produk",
                                  style: smallColorFontGrey,
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.productName!.toString(),
                                  style: largeBlackText,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 8, bottom: 8),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
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
                                  dateController.text = DateFormat("yyyy-MM-dd")
                                      .format(pickedDate);
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
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1C4966)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Pilih tanggal kadaluarsa",
                                hintStyle: smallColorFontGrey,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 5,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "* Input stock awal",
                                          style: smallBlackText,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF1C4966)),
                                              onPressed: () {
                                                setState(() {
                                                  if (counter > 0) {
                                                    counter--;
                                                  }
                                                  numberController.text =
                                                      '$counter';
                                                });
                                              },
                                              child: Text(
                                                '-',
                                                style: smallWhiteText,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: 50,
                                              child: TextFormField(
                                                controller: numberController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.center,
                                                onChanged: (value) {
                                                  int? parsedValue =
                                                      int.tryParse(value);
                                                  if (parsedValue != null) {
                                                    setState(() {
                                                      counter = parsedValue;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF1C4966)),
                                              onPressed: () {
                                                setState(() {
                                                  counter++;
                                                  numberController.text =
                                                      '$counter';
                                                });
                                              },
                                              child: Text('+',
                                                  style: smallWhiteText),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  // pembatas stock akhir stock awal
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "* Input stock akhir",
                                        style: smallBlackText,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF1C4966)),
                                            onPressed: () {
                                              setState(() {
                                                if (endStockCounter > 0) {
                                                  endStockCounter--;
                                                }
                                                endStockController.text =
                                                    '$endStockCounter';
                                              });
                                            },
                                            child: Text('-',
                                                style: smallWhiteText),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 50,
                                            child: TextFormField(
                                              controller: endStockController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                int? parsedValue =
                                                    int.tryParse(value);
                                                if (parsedValue != null) {
                                                  setState(() {
                                                    endStockCounter =
                                                        parsedValue;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF1C4966)),
                                            onPressed: () {
                                              setState(() {
                                                endStockCounter++;
                                                endStockController.text =
                                                    '$endStockCounter';
                                              });
                                            },
                                            child: Text(
                                              '+',
                                              style: smallWhiteText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                    borderRadius: BorderRadius.circular(8),
                                    onPressed: () async {
                                      CoolAlert.show(
                                          confirmBtnColor:
                                              const Color(0xFF661C63),
                                          confirmBtnText: "Update sekarang",
                                          confirmBtnTextStyle: smallWhiteText,
                                          cancelBtnText: "Kembali",
                                          cancelBtnTextStyle:
                                              smallColorFontGrey,
                                          backgroundColor:
                                              const Color(0xFF661C63),
                                          animType: CoolAlertAnimType.slideInUp,
                                          title:
                                              "Apakah sudah sesuai dengan stok yang tersedia?",
                                          titleTextStyle: standarBlackText,
                                          context: context,
                                          type: CoolAlertType.confirm,
                                          onConfirmBtnTap: () {
                                            var data = UpdateStockModel(
                                                customerId: widget.customerId,
                                                materialId: widget.materialId,
                                                expDate: dateController.text,
                                                stockOut:
                                                    endStockController.text,
                                                stockQty:
                                                    numberController.text);
                                            context
                                                .read<StockBloc>()
                                                .updateStock(
                                                    formData: data,
                                                    context: context,
                                                    onSuccess: () {
                                                      Get.off(
                                                          StockProductScreen(
                                                        customerId: customerId,
                                                        customerName:
                                                            customerName,
                                                        address: address,
                                                      ));
                                                    });
                                          });
                                    },
                                    child: Text(
                                      "Perbarui stock",
                                      style: smallWhiteText,
                                    ))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
