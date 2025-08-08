import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:traxes/bloc/feature/display_mbd/display.mbd.bloc.dart';
import 'package:traxes/constant/screen/card.display.mbd.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/display_mbd/SMD/insert.display.mbd.dart';

class DisplayMbdScreen extends StatefulWidget {
  final String? customerName;
  final String? address;  
  final String? customerId;

  const DisplayMbdScreen(
      {super.key, this.customerName, this.address, this.customerId});

  @override
  State<DisplayMbdScreen> createState() => _DisplayMbdScreenState();
}


class _DisplayMbdScreenState extends State<DisplayMbdScreen> {

  @override
  void initState() {
    super.initState();
    context.read<DisplayMbdBloc>().getMbdDisplay(context: context);
  }

  
  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  expandedHeight: isLandscape ? 220 : 50,
                  flexibleSpace: SizedBox(
                    child: FlexibleSpaceBar(
                      background: Container(
                        color: Colors.white,
                      ),
                      title: Text(
                        "Display MBD",
                        style: largeBlackTextB,
                      ),
                    ),
                  ),
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Card(
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.shop,
                                      color: Color(0xFF1C4966)),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      "Lokasi: ${widget.customerName ?? ''}",
                                      style: smallBlackTextB,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.idBadge,
                                      color: Color(0xFF1C4966)),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      "ID: ${widget.customerId ?? ''}",
                                      style: smallBlackTextB,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.locationDot,
                                      color: Color(0xFF1C4966)),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      "Alamat: ${widget.address ?? ''}",
                                      style: smallBlackTextB,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Other Modern Cards
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: ModernCard(
                          
                          imageUrl: 'https://via.placeholder.com/150',
                          date: DateTime.now(),
                          status: 'Active',
                        ),
                      ),
                      const SizedBox(height: 16),

                     
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(InsertDisplayMbdScreen(
                    customerId: widget.customerId,
                    customerName: widget.customerName,
                    address: widget.address,
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C4966),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Tambah display',
                  style: largeWhiteText
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
