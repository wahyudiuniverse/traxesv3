import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:traxes/bloc/feature/delete_sku/delete.sku.bloc.dart';
import 'package:traxes/bloc/feature/delete_sku/delete.sku.state.dart';
import 'package:traxes/bloc/user/look_order/look.order.bloc.dart';
import 'package:traxes/bloc/user/look_order/look.order.state.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/constant/widget/customer.card.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/widget/rupiah.converter.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/model/delete_sku/delete,sku.model.dart';
import 'package:traxes/presentation/feature/sku/input_order/sku.dart';

class OrderScreen extends StatefulWidget {
  final String? customerName;
  final String? address;
  final String? customerId;
  const OrderScreen(
      {super.key, this.customerName, this.address, this.customerId});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? customerName;
  String? address;
  String? customerId;
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    context.read<LookOrderBloc>().getLookOrder(context: context);
    checkConnectivityAndNavigate();
  }

  Future<void> onRefresh() async {
    context.read<LookOrderBloc>().getLookOrder(context: context);
    refreshController.refreshCompleted();
  }

  void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
        Get.back();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Order/Sell Out",
          style: standarWhiteTextB,
        ),
      ),
      body: SafeArea(
        child: SmartRefresher(
          controller: refreshController,
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                BlocBuilder<LookOrderBloc, LookOrderState>(
                  builder: (context, stateOrder) {
                    if (stateOrder is LookOrderLoaded) {
                      if (stateOrder.data.isNotEmpty) {
                        return ListView.builder(
                          itemCount: stateOrder.data.length,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            var order = stateOrder.data[i];
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
                                                  order.namaMaterial.toString(),
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
                                                  "Harga barang: ${RupiahConverter().formatToRupiah(int.parse(order.price.toString()))}",
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
                                                  "Total penjualan: ${RupiahConverter().formatToRupiah(int.parse(order.total.toString()))}",
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
                                                  "Jumlah: ${order.qty.toString()}",
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
                                                  "Tanggal dibuat: ${DateFormat("EEEEE, dd, yyyy").format(DateTime.parse(order.orderDate.toString()))}",
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
                                                child: GestureDetector(
                                                    child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF1C4966),
                                                            title: Text(
                                                                "Informasi Produk",
                                                                style:
                                                                    standarWhiteTextB),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      "Nama Produk : ${order.namaMaterial}",
                                                                      style:
                                                                          smallWhiteText),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      "Jumlah Barang : ${order.qty}",
                                                                      style:
                                                                          smallWhiteText),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      "Harga Barang : ${RupiahConverter().formatToRupiah(int.parse(order.price.toString()))}",
                                                                      style:
                                                                          smallWhiteText),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      "Total : ${RupiahConverter().formatToRupiah(int.parse(order.total.toString()))}",
                                                                      style:
                                                                          smallWhiteText),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                              ],
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  'Tutup',
                                                                  style:
                                                                      smallWhiteText,
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFFFFFFFF)),
                                                                onPressed: () {
                                                                  final deleteModel = DeleteSKUModel(
                                                                      idorder: order
                                                                          .secid
                                                                          .toString());

                                                                  context
                                                                      .read<
                                                                          DeleteSkuBloc>()
                                                                      .deleteSku(
                                                                          deleteModel,
                                                                          context)
                                                                      .then(
                                                                          (_) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    setState(
                                                                        () {
                                                                      onRefresh();
                                                                    });
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "Hapus Produk",
                                                                  style:
                                                                      smallColoredText,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }),
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
                              Text("Data penjualan kosong",
                                  style: largeBlackText),
                            ],
                          ),
                        );
                      }
                    } else if (stateOrder is SuccessDeleteSku) {
                      setState(() {});
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
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
                        Get.to(InputSkuScreen(
                          customerId: widget.customerId,
                          customerName: widget.customerName,
                        ));
                      },
                      child: Text(
                        "Buat Order/Sell-out",
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
