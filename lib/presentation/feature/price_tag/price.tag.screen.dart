import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:traxes/bloc/feature/price_tag/price.tag.bloc.dart';
import 'package:traxes/bloc/feature/price_tag/price.tag.state.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/custom.button.dart';
import 'package:traxes/presentation/feature/price_tag/add.price.tag.screen.dart';

class PriceTagScreen extends StatefulWidget {
  final String? customerName;
  final String? address;
  final String? customerId;
  
  const PriceTagScreen({super.key, this.customerName, this.address, this.customerId});

  @override
  State<PriceTagScreen> createState() => _PriceTagScreenState();
}

class _PriceTagScreenState extends State<PriceTagScreen> {
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    context.read<PriceTagBloc>().getPriceTag(context: context);
  }

  Future<void> onRefresh() async {
    context.read<PriceTagBloc>().getPriceTag(
      context: context
    );
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Price Tag",
          style: standarWhiteTextB,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF661C63), // Start color (vibrant purple)
                      Color(0xFF1C4966), // End color
                    ],
                  ),
                ),
                height: MediaQuery.of(context).size.height / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/add-toko-new-removebg-preview.png",
                      color: Colors.white,
                      width: 90,
                      height: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.customerName.toString(),
                      style: standarWhiteText,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.address.toString(),
                      style: standarWhiteText,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.customerId.toString().isEmpty
                          ? "Kosong"
                          : widget.customerId.toString(),
                      style: standarWhiteText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Table(
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C4966),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  children: [
                    TableCell(
                      child: Text(
                        "Nama material",
                        textAlign: TextAlign.center,
                        style: standarWhiteText,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Harga",
                        textAlign: TextAlign.center,
                        style: standarWhiteText,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Foto",
                        textAlign: TextAlign.center,
                        style: standarWhiteText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PriceTagBloc, PriceTagState>(
              builder: (context, priceTagState) {
                if (priceTagState is PriceTagLoaded) {
                  return SmartRefresher(
                    controller: refreshController,
                    onRefresh: onRefresh,
                    enablePullDown: true,
                    enablePullUp: false,
                    header: const WaterDropMaterialHeader(
                      backgroundColor: Color(0xFF1C4966),
                    ),
                    child: ListView.builder(
                      itemCount: priceTagState.data.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, i) {
                        var priceTag = priceTagState.data[i];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Table(
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        priceTag.namaMaterial.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        maxLines: 3,
                                        style: standarColorFontGrey,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Rp. ${priceTag.price.toString()}",
                                        textAlign: TextAlign.center,
                                        style: standarColorFontGrey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Handle the tap event here
                                      },
                                      child: Center(
                                        child: priceTag.foto != null
                                            ? Image.network(
                                                "https://api.traxes.id/${priceTag.foto}",
                                                width: 170,
                                                height: 170,
                                              )
                                            : Text(
                                                "No Image",
                                                textAlign: TextAlign.center,
                                                style: standarColorFontGrey,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Jika price tag kosong setelah menambahkan material, harap kembali ke menu utama dan masuk ke dalam menu price tag ^^",
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                borderRadius: BorderRadius.circular(8),
                onPressed: () {
                  Get.to(
                    AddPriceTagScreen(
                      customerId: widget.customerId,
                    ),
                  );
                },
                child: Text(
                  "Tambah material",
                  style: smallWhiteText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
