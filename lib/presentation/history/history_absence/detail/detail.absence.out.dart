import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:traxes/bloc/history/history_absence_detail/history.absence.detail.bloc.dart';
import 'package:traxes/bloc/history/history_absence_detail/history.absence.detail.state.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/history/history_absence/history.absence.dart';

class DetailAbsenceOutScreen extends StatefulWidget {
  final String? secid;
  final String? dateCio;
  final String? inTime;
  final String? outTime;
  final String? customerName;
  final String? customerId;
  const DetailAbsenceOutScreen(
      {super.key,
      this.secid,
      this.dateCio,
      this.inTime,
      this.outTime,
      this.customerName,
      this.customerId});

  @override
  State<DetailAbsenceOutScreen> createState() => _DetailAbsenceScreenState();
}


class _DetailAbsenceScreenState extends State<DetailAbsenceOutScreen> {
  @override
  void initState() {
    super.initState();
    widget.customerId;
    widget.dateCio;
    context.read<DetailAbsenceBloc>().getDetail(secid: widget.secid, context: context);
  }

  void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
        Get.offAll(const HistoryAbsenceScreen());
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Detail Absen Check-Out",
          style: standarWhiteTextB,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<DetailAbsenceBloc, HistoryDetailState>(
                  builder: (context, detailHistory) {
                    if (detailHistory is HistoryDetailLoaded) {
                      return ListView.builder(
                        itemCount: detailHistory.data.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          var detail = detailHistory.data[0];
                          DateTime dateCio =
                              DateTime.parse(detail.dateCio.toString());
                          String formattedDate =
                              DateFormat('dd MMMM yyyy').format(dateCio);
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF661C63),
                                        Color(0xFF1C4966),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: detail.fotoout != null &&
                                              detail.fotoout
                                                  .toString()
                                                  .isNotEmpty
                                          ? Image.network(
                                              detail.fotoout.toString(),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/images/blue-person.png",
                                              color: Colors.white,
                                            )),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  detail.fullname.toString(),
                                  style: extraLargePurpleTextB,
                                ),
                              ),
                              Center(
                                child: Text(
                                  detail.jabatan.toString(),
                                  style: standarPurpleText,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  formattedDate,
                                  style: standarPurpleTextB,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          flex: -1,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFF661C63),
                                                    Color(
                                                        0xFF1C4966), // End color
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: SizedBox(
                                                height: 110,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 35,
                                                      width: 100,
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                        child: Center(
                                                          child: Text(
                                                            "Jam keluar",
                                                            style:
                                                                extraSmallRedText,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      widget.outTime != null && widget.outTime!.length >= 6 ? widget.outTime!.substring(0, 6) : "-",
                                                     
                                                      style: largeWhiteTextB,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color(
                                                                  0xFF661C63), // Start color (vibrant purple)
                                                              Color(
                                                                  0xFF1C4966), // End color
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: SizedBox(
                                                          height: 45,
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5),
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/images/logo kompas untuk latlong traxes.png",
                                                                    height: 20,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Expanded(
                                                                  child: Text(
                                                                    detail.latitudeOut ==
                                                                                null ||
                                                                            detail.latitudeOut.toString().isEmpty
                                                                        ? "-"
                                                                        : "${detail.latitudeOut.toString()} \n ${detail.longitudeOut.toString()} ",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 3,
                                                                    style:
                                                                        smallWhiteText,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  SizedBox(
                                                    width:
                                                        100, // You can adjust this width as needed
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Color(
                                                                  0xFF661C63), // Start color (vibrant purple)
                                                              Color(
                                                                  0xFF1C4966), // End color
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: SizedBox(
                                                          height: 45,
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Jarak",
                                                                  style:
                                                                      smallWhiteText,
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                Expanded(
                                                                    child: Text(
                                                                  detail.distanceOut ==
                                                                              null ||
                                                                          detail
                                                                              .distanceOut
                                                                              .toString()
                                                                              .isEmpty
                                                                      ? "-"
                                                                      : "${double.parse(detail.distanceOut!).toStringAsFixed(2).replaceAll('.', ',')} m",
                                                                  style:
                                                                      smallWhiteText,
                                                                )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                width:
                                                    constraints.maxWidth * 0.9,
                                                height:
                                                    55, // You can adjust this height as needed
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Color(
                                                              0xFF661C63), // Start color (vibrant purple)
                                                          Color(
                                                              0xFF1C4966), // End color
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: SizedBox(
                                                      height: 35,
                                                      child: Row(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Icon(
                                                              Icons
                                                                  .location_pin,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 15),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Lokasi Check-out",
                                                                style:
                                                                    smallWhiteText,
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                detail.distanceOut ==
                                                                            null ||
                                                                        detail
                                                                            .distanceOut
                                                                            .toString()
                                                                            .isEmpty
                                                                    ? "-"
                                                                    : detail
                                                                        .customerName
                                                                        .toString(),
                                                                style:
                                                                    smallWhiteText,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    "Powered by:",
                    style: standarBlackTextBI,
                  ),
                  Image.asset(
                    height: 100,
                    "assets/images/traxes-icon.png", // Replace with your image path
                    fit: BoxFit.contain, // Adjust the fit as needed
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
