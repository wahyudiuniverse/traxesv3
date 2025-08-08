import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:traxes/bloc/feature/stock/stock.bloc.dart';
import 'package:traxes/bloc/feature/stock/stock.state.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/customer.card.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/presentation/feature/stock_product/input_stock/input.stock.screen.dart';
import 'package:traxes/presentation/feature/stock_product/input_stock/update.material.screen.dart';

class StockProductScreen extends StatefulWidget {
  final String? customerName;
  final String? address;
  final String? customerId;
  const StockProductScreen(
      {super.key, this.customerName, this.address, this.customerId});

  @override
  State<StockProductScreen> createState() => _StockProductScreenState();
}

class _StockProductScreenState extends State<StockProductScreen> {
  String? customerName;
  String? address;
  String? customerId;
  final refreshController = RefreshController();

  Future<void> onRefresh() async {
    context.read<StockBloc>().getStock(context: context);
    refreshController.refreshCompleted();
  }

  void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<StockBloc>().getStock(context: context);
    checkConnectivityAndNavigate();
  }

  @override
  void dispose() {
    super.dispose();
    ConnectivityHelper.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Stock Product",
          style: standarWhiteTextB,
        ),
      ),
      body: SafeArea(
        child: SmartRefresher(
          controller: refreshController,
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: 8, left: 8, top: 15, bottom: 8),
                  child: CustomerInfoCard(
                    customerId: widget.customerId.toString(),
                    customerName: widget.customerName.toString(),
                    address: widget.address.toString(),
                  ),
                ),
                const SizedBox(height: 15),
                BlocBuilder<StockBloc, StockState>(
                  builder: (context, stockState) {
                    if (stockState is StockLoaded) {
                      if (stockState.data.isNotEmpty) {
                        return ListView.builder(
                          itemCount: stockState.data.length,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            var stock = stockState.data[i];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    top: 8,
                                  ),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: SizedBox(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 8),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  stock.namaMaterial.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  style: standarBlackTextB,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Tanggal kadaluarsa: ${stock.expDate}",
                                                  style: smallColorFontGrey,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Tanggal dibuat: ${stock.stockDate}",
                                                  style: smallColorFontGrey,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Stock awal: ${stock.stockQty.toString()}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 3,
                                                  style: smallColorFontGrey,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                              ),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Stock akhir: ${stock.stockOut == null ? "Belum di isi" : stock.stockOut.toString()}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 3,
                                                  style: smallColorFontGrey,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 13, bottom: 13),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: CustomButton(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    onPressed: () {
                                                      Get.to(
                                                          UpdateMaterialScreen(
                                                        productName: stock
                                                            .namaMaterial
                                                            .toString(),
                                                        customerId:
                                                            widget.customerId,
                                                        materialId:
                                                            stock.materialId,
                                                      ));
                                                    },
                                                    child: Text(
                                                      "Edit stock",
                                                      style: smallWhiteText,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
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
                              Text("Data stock kosong", style: largeBlackText),
                            ],
                          ),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      borderRadius: BorderRadius.circular(8),
                      onPressed: () {
                        ConnectivityHelper.dispose();
                        Get.to(InputStockScreen(
                          customerId: widget.customerId,
                          customerName: widget.customerName,
                        ));
                      },
                      child: Text(
                        "Tambah stock produk",
                        style: standarWhiteText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
