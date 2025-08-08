import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/getx/skusearch.controller.dart';
import 'package:traxes/presentation/feature/stock_product/input_stock/input.stock.screen.dart';

class SearchStock extends StatefulWidget {
  const SearchStock({super.key});

  @override
  State<SearchStock> createState() => _SearchStockState();
}

class _SearchStockState extends State<SearchStock> {
  final productController = TextEditingController();
  final search = TextEditingController();

  bool isListViewVisible = true;


  String? uomTotal;

  String? selectOrder;

  
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
                          icon: const Icon(Icons.search,
                              color: Color(0xFF1C4966)),
                          onPressed: () {
                            setState(() {
                              searchController.loadLocalSkuSearch(search.text.toString(),
                                  () {
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
                              Get.off(InputStockScreen(
                                productId: productController.text,
                                uomTotal: uomTotal,
                                productName: outlet.namaMaterial,
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
