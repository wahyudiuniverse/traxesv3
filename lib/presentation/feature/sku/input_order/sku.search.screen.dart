import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/getx/skusearch.controller.dart';
import 'package:traxes/presentation/feature/sku/input_order/sku.dart';
import 'package:flutter_barcode_scanner_update/flutter_barcode_scanner_update.dart';

class SearchSku extends StatefulWidget {
  const SearchSku({super.key});

  @override
  State<SearchSku> createState() => _SearchSkuState();
}

class _SearchSkuState extends State<SearchSku> {
  final productController = TextEditingController();
  final search = TextEditingController();

  bool isListViewVisible = true;

  String? totalPrice;

  String? uomTotal;

  String? selectOrder;

  String? totalOrder;
  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(SkuSearchGetX());

    return Scaffold(
        appBar: GradientAppBar(
          title: Text(
            "Cari Material/SKU",
            style: standarWhiteTextB,
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: TextFormField(
                          controller: search,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF1C4966),
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF1C4966)),
                            ),
                            hintText: "Cari Material/Sku",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 15,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF1C4966)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          hoverColor: const Color(0xFF1C4966),
                          icon: const Icon(Icons.qr_code_scanner,
                              color: Color(0xFF1C4966)),
                          onPressed: () async {
                            String barcode = await FlutterBarcodeScanner.scanBarcode(
                              "#ff1a1a", 
                              "Batal", 
                              false,
                              ScanMode.BARCODE
                            );
                            
                            debugPrint('barcode: $barcode');

                            setState(() {
                              searchController.loadLocalSkuScan(
                                barcode, () {
                                setState(() {
                                  isListViewVisible = true;
                                });
                              });
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 15,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF1C4966)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          hoverColor: const Color(0xFF1C4966),
                          icon: const Icon(Icons.search,
                              color: Color(0xFF1C4966)),
                          onPressed: () {
                            setState(() {
                              searchController.loadLocalSkuSearch(
                                  search.text.toString(), () {
                                setState(() {
                                  isListViewVisible = true;
                                });
                              });
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
                  child: ListView.builder(
                    itemCount: searchController.dataResults.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, i) {                      
                      dynamic outlet = searchController.dataResults[i];
                      debugPrint(outlet.barcode);
                      return Column(children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectOrder = outlet.kodeSku.toString();
                              productController.text = selectOrder.toString();
                              final selectedProduct = searchController
                                  .dataResults
                                  .firstWhere((e) => e.kodeSku == selectOrder);
                              uomTotal = selectedProduct.price.toString();
                              Get.off(InputSkuScreen(
                                productId: productController.text,
                                uomTotal: uomTotal,
                                price: outlet.price,
                                productName: outlet.namaMaterial,
                                point: outlet.poin,
                                volume: outlet.volume,
                              ));
                              // isListViewVisible = false;
                            });
                          },
                          child: Card(
                              child: ListTile(
                                  // ignore: prefer_const_constructors
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.shopping_basket,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                  subtitle: Text(
                                    outlet.brand.toString(),
                                    style: smallBlackText,
                                  ),
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        outlet.namaMaterial.toString(),
                                        style: largeBlackText,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        outlet.kodeSku.toString(),
                                        style: smallBlackText,
                                      ),
                                    ],
                                  ))),
                        )
                      ]);
                    },
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
