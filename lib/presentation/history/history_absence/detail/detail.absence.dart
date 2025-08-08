import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:traxes/bloc/history/history_absence_detail/history.absence.detail.bloc.dart';
import 'package:traxes/bloc/history/history_absence_detail/history.absence.detail.state.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';

class DetailAbsenceScreen extends StatefulWidget {
  final String? secid;
  final String? dateCio;
  final String? inTime;
  final String? outTime;
  final String? customerName;
  final String? customerId;
  const DetailAbsenceScreen(
      {super.key,
      this.secid,
      this.dateCio,
      this.inTime,
      this.outTime,
      this.customerName,
      this.customerId});

  @override
  State<DetailAbsenceScreen> createState() => _DetailAbsenceScreenState();
}

class _DetailAbsenceScreenState extends State<DetailAbsenceScreen> {
  @override
  void initState() {
    super.initState();
    widget.customerId;
    widget.dateCio;
    context.read<DetailAbsenceBloc>().getDetail(secid: widget.secid, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Detail Absen Check-In",
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
                                        Color(
                                            0xFF661C63), // Start color (vibrant purple)
                                        Color(0xFF1C4966), // End color
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      detail.fotoin.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
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
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          flex: -1,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(
                                                        0xFF661C63), // Start color (vibrant purple)
                                                    Color(0xFF1C4966), // End color
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
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Jam masuk",
                                                            style:
                                                                extraSmallGreenText,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      widget.inTime
                                                          .toString()
                                                          .substring(0, 6),
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
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(10),
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            begin: Alignment.topLeft,
                                                            end:
                                                                Alignment.bottomRight,
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
                                                                          left: 5),
                                                                  child: Image.asset(
                                                                    "assets/images/logo kompas untuk latlong traxes.png",
                                                                    height: 20,
                                                                    color:
                                                                        Colors.white,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Expanded(
                                                                  child: Text(
                                                                  "${  
                                                                    detail.latitudeIn
                                                                        .toString()} \n ${  
                                                                    detail.longitudeIn
                                                                        .toString()} ",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 2,
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
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(10),
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            begin: Alignment.topLeft,
                                                            end:
                                                                Alignment.bottomRight,
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
                                                                    detail.distanceIn !=
                                                                            null
                                                                        ? '${double.parse(detail.distanceIn!).toStringAsFixed(2).replaceAll('.', ',')} m' // Parse, round, and convert back to string
                                                                        : "-",
                                                                    style:
                                                                        smallWhiteText,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                  ),
                                                                ),
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
                                                width: constraints.maxWidth * 0.9,
                                                height:
                                                    55, // You can adjust this height as needed
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Color(
                                                              0xFF661C63), // Start color (vibrant purple)
                                                          Color(
                                                              0xFF1C4966), // End color
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                    ),
                                                    child: SizedBox(
                                                      height: 35,
                                                      child: Row(
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 10),
                                                            child: Icon(
                                                              Icons.location_pin,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 15),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Lokasi Check-in",
                                                                style: smallWhiteText,
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                detail.customerName
                                                                    .toString(),
                                                                style: smallWhiteText,
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
                              
                              const SizedBox(height: 50),
                              // logo footer
                              Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  children: [
                                    Text("Powered by:", style: standarBlackTextBI,),
                                    Image.asset(
                                      height: 100,
                                      "assets/images/traxes-icon.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ],
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
            
          ],
        ),
      ),
    );
  }
}
