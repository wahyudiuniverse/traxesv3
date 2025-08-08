import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:traxes/constant/screen/detail.image.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/widget/mini.card.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/absence/check-in/submit.absence.screen.dart';

class DetailOutletScreen extends StatefulWidget {
  final String? alamat;
  final String? toko;
  final String? projectId;
  final String? customerId;
  final String? latToko;
  final String? longToko;
  final String? photo;
  final String? verify;
  const DetailOutletScreen(
      {super.key,
      this.alamat,
      this.toko,
      this.projectId,
      this.customerId,
      this.latToko,
      this.longToko,
      this.photo,
      this.verify});

  @override
  State<DetailOutletScreen> createState() => _DetailOutletScreenState();
}

class _DetailOutletScreenState extends State<DetailOutletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
          title: Text(
        "Informasi toko",
        style: standarWhiteTextB,
      )),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  if (widget.photo != null && widget.photo!.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailFullScreenImageScreen(
                          imageBytes:
                              null, // Placeholder, since we will use NetworkImage
                          imageUrl: widget.photo,
                        ),
                      ),
                    );
                  }
                },
                child: widget.photo == null || widget.photo!.isEmpty
                    ? Image.asset("assets/images/traxes-icon.png",
                        fit: BoxFit.cover)
                    : Image.network(
                        widget.photo!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.toko.toString(), style: largeBlackTextB),
                  const SizedBox(height: 10.0),
                  Text(widget.alamat.toString(), style: standarBlackText),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Latitude", style: standarBlackText),
                      Text(
                        widget.latToko.toString(),
                        style: standarBlackTextB,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Longitude", style: standarBlackText),
                      Text(
                        widget.longToko.toString(),
                        style: standarBlackTextB,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Status", style: standarBlackText),
                      widget.verify == "1"
                          ? SizedBox(
                              width: 110,
                              height: 35,
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xFF6A8C38)),
                                  child: Center(
                                    child: Text(
                                      "Terverifikasi",
                                      style: extraSmallWhiteTextB,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 135,
                              height: 35,
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xFF953553)),
                                  child: Center(
                                    child: Text(
                                      "Belum terverifikasi",
                                      style: extraSmallWhiteTextB,
                                    ),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                  const SizedBox(height: 5),
                  CustomCard(
                    icon: Icons.edit,
                    title: 'Edit',
                    color: const Color(0xFF1C4966),
                    titleStyle: standarBlackTextB,
                    onTap: () {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.info,
                          text: "Coming soon");
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomCard(
                    icon: Icons.verified,
                    color: const Color(0xFF6A8C38),
                    title: 'Verifikasi',
                    titleStyle: standarBlackTextB,
                    onTap: () {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.info,
                          text: "Coming soon");
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomCard(
                    icon: FontAwesomeIcons.fingerprint,
                    color: const Color(0xFF6A8C38),
                    title: 'Check-in',
                    titleStyle: standarBlackTextB,
                    onTap: () {
                      Get.to(SubmitAbsenceScreen(
                        toko: widget.toko,
                        alamat: widget.alamat,
                        latToko: widget.latToko,
                        longToko: widget.longToko,
                        customerId: widget.customerId,
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
