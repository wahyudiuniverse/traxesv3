import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/history/history_outlet/history.outlet.state.dart';
import 'package:traxes/bloc/history/local_history_outlet/local.history.outlet.bloc.dart';
import 'package:traxes/bloc/history/local_history_outlet/local.history.outlet.state.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';

import 'package:traxes/constant/text.style.dart';
import 'package:traxes/database_offline/db.customer.dart';
import 'package:traxes/getx/search_history.controller.dart';
import 'package:traxes/presentation/feature/absence/absence.screen.dart';
import 'package:traxes/presentation/feature/absence/check-in/detail.outlet.screen.dart';

class HistoryOutletScreen extends StatefulWidget {
  const HistoryOutletScreen({super.key});

  @override
  State<HistoryOutletScreen> createState() => _HistoryOutletScreenState();
}

class _HistoryOutletScreenState extends State<HistoryOutletScreen> {
  final searchController = Get.put(SearchHistoryGetx());
  final search = TextEditingController();
  bool showSearchResult = false;
  String lastDownloadKey = '';

  void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
        Get.offAll(const AbsenceScreen());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkAndRefreshData();
    checkConnectivityAndNavigate();
  }

  Future<void> checkAndRefreshData() async {
    final localHistoryOutlet = context.read<LocalHistoryOutletBloc>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? lastDownloadDate = prefs.getString(lastDownloadKey);

    if (lastDownloadDate == null || lastDownloadDate != currentDate) {
      DBCustomerHelper().deleteCustomerDB();
      localHistoryOutlet.loadLocalOutlet();

      prefs.setString(lastDownloadKey, currentDate);
    } else {
      localHistoryOutlet.loadLocalOutlet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Riwayat Absen",
          style: standarWhiteTextB,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 25, top: 10, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: search,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Color(0xFF1C4966), width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Color(0xFF1C4966))),
                        hintText: "Search",
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFF1C4966)),
                      onPressed: () {
                        setState(() {
                          searchController
                              .onChangeSearchNew(search.text.toString(), () {
                            setState(() {
                              showSearchResult = true;
                            });
                          });
                        });
                      }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 25,
                left: 10,
                right: isPortrait ? 10 : 20,
              ),
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount:
                    showSearchResult ? searchController.dataResult.length : 0,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  dynamic outlet = searchController.dataResult[i];

                  return GestureDetector(
                    onTap: () {
                      ConnectivityHelper.dispose();
                      Get.to(DetailOutletScreen(
                        toko: outlet.customerName,
                        alamat: outlet.address,
                        latToko: outlet.latitude,
                        longToko: outlet.longitude,
                        customerId: outlet.customerId,
                        verify: outlet.verify,
                      ));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home, color: Colors.black),
                          ],
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(outlet.customerName.toString(),
                                style: largeBlackText),
                            const SizedBox(height: 10),
                            Text(outlet.customerId.toString(),
                                style: smallBlackText),
                          ],
                        ),
                        subtitle: Text(outlet.address.toString(),
                            style: smallBlackText),
                      ),
                    ),
                  );
                },
              ),
            ),
            BlocBuilder<LocalHistoryOutletBloc, LocalOutletState>(
              builder: (context, stateOutlet) {
                if (stateOutlet is LocalOutletLoaded) {
                  return
                       SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: isPortrait ? 10 : 20,
                                ),
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                  itemCount: showSearchResult
                                      ? searchController.dataResult.length
                                      : stateOutlet.data.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    dynamic outlet =
                                        searchController.dataResult.isEmpty
                                            ? stateOutlet.data[i]
                                            : searchController.dataResult[i];

                                    return GestureDetector(
                                      onTap: () {
                                        ConnectivityHelper.dispose();
                                        Get.to(DetailOutletScreen(
                                          toko: outlet.customerName,
                                          alamat: outlet.address,
                                          latToko: outlet.latitude,
                                          longToko: outlet.longitude,
                                          customerId: outlet.customerId,
                                          verify: outlet.verify,
                                        ));
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: ListTile(
                                          leading: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.home,
                                                  color: Colors.black),
                                            ],
                                          ),
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  outlet.customerName
                                                      .toString(),
                                                  style: largeBlackText),
                                              const SizedBox(height: 10),
                                              Text(outlet.customerId.toString(),
                                                  style: smallBlackText),
                                            ],
                                          ),
                                          subtitle: Text(
                                              outlet.address.toString(),
                                              style: smallBlackText),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      
                } else if (stateOutlet is HistoryOutletLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
