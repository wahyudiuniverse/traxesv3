import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:traxes/bloc/history/history_absence_bloc/history.absence.bloc.dart';
import 'package:traxes/bloc/history/history_absence_bloc/history.absence.state.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/dashboard/dashboard.screen.dart';
import 'package:traxes/presentation/history/history_absence/detail/detail.absence.dart';
import 'package:traxes/presentation/history/history_absence/detail/detail.absence.out.dart';

class HistoryAbsenceScreen extends StatefulWidget {
  const HistoryAbsenceScreen({super.key});

  @override
  State<HistoryAbsenceScreen> createState() => _HistoryAbsenceScreenState();
}

class _HistoryAbsenceScreenState extends State<HistoryAbsenceScreen> {
  String safeSubstring(String input, int start, int end) {
    if (input.length > end) {
      return input.substring(start, end);
    } else if (input.length > start) {
      return input.substring(start);
    } else {
      return "-";
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<HistoryAbsenceBloc>().getHistoryAbsence(context: context);
    checkConnectivityAndNavigate();
  }

  void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
        Get.offAll(const DashboardScreen());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Riwayat absensi",
          style: standarWhiteTextB,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: BlocBuilder<HistoryAbsenceBloc, HistoryAbsenceState>(
            builder: (context, stateHistory) {
              if (stateHistory is HistoryAbsenceLoaded) {
                return Center(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: Column(
                          children: [
                            ListView.builder(
                              itemCount: stateHistory.data.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context, i) {
                                var phoneIn = safeSubstring(
                                    stateHistory.data[i].datetimephoneIn
                                        .toString(),
                                    10,
                                    19);
                                var phoneOut = safeSubstring(
                                    stateHistory.data[i].datetimephoneOut
                                        .toString(),
                                    10,
                                    19);

                                var history = stateHistory.data[i];

                                DateTime dateCio =
                                    DateTime.parse(history.dateCio.toString());
                                String formatDateCio =
                                    DateFormat('dd MMMM yyyy').format(dateCio);
                                return GestureDetector(
                                  onTap: () {
                                    // Proceed to show detail screen
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Detail absen',
                                              style: largeBlackText),
                                          content: Text('Pilih detail absen',
                                              style: standarBlackTextB),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Card(
                                                  color:
                                                      const Color(0xFF2AAA8A),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Get.to(
                                                          DetailAbsenceScreen(
                                                        secid: history.secid,
                                                        customerId:
                                                            history.customerId,
                                                        customerName: history
                                                            .customerName,
                                                        dateCio:
                                                            history.dateCio,
                                                        inTime: phoneIn,
                                                        outTime: phoneOut,
                                                      ));
                                                    },
                                                    child: Text(
                                                        'Detail Check-in',
                                                        style:
                                                            extraSmallWhiteText),
                                                  ),
                                                ),
                                                Card(
                                                  color:
                                                      const Color(0xFFC41E3A),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Get.to(
                                                          DetailAbsenceOutScreen(
                                                        secid: history.secid,
                                                        customerId:
                                                            history.customerId,
                                                        customerName: history
                                                            .customerName,
                                                        dateCio:
                                                            history.dateCio,
                                                        inTime: phoneIn,
                                                        outTime: phoneOut,
                                                      ));
                                                    },
                                                    child: Text(
                                                        'Detail Check-out',
                                                        style:
                                                            extraSmallWhiteText),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Card(
                                          color: const Color(0xFF436EA2),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 10),
                                                Text("Tanggal: $formatDateCio",
                                                    style: smallWhiteText),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        color: Colors.green,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text("Jam Masuk",
                                                          style:
                                                              extraSmallGreenText),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        color: Colors.red,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text("Jam Keluar",
                                                          style:
                                                              extraSmallRedText),
                                                    ],
                                                  ),
                                                  const Row(
                                                    children: [
                                                      SizedBox(width: 5),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      Text(phoneIn,
                                                          style:
                                                              standarGreenText),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(phoneOut,
                                                          style:
                                                              standarRedText),
                                                    ],
                                                  ),
                                                  const Row(
                                                    children: [
                                                      SizedBox(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_pin,
                                                    color: Colors.green,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      history.customerName
                                                          .toString(),
                                                      style: standarColoredText,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (stateHistory is HistoryAbsenceLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (stateHistory is HistoryAbsenceTimeOut) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      
                      backgroundColor: Colors.red,
                      content: Text(stateHistory.message, style: largeWhiteText,),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                });
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text("No respond"));
              }
            },
          ),
        ),
      ),
    );
  }
}
