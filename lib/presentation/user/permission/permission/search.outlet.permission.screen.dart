import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:traxes/bloc/history/history_outlet/history.outlet.bloc.dart';
import 'package:traxes/bloc/history/history_outlet/history.outlet.state.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/sharedprefs.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/getx/search_history.controller.dart';
import 'package:traxes/presentation/user/permission/permission/permission.screen.dart';

class PermissionOutletScreen extends StatefulWidget {
  const PermissionOutletScreen({super.key});

  @override
  State<PermissionOutletScreen> createState() => _PermissionOutletScreenState();
}

class _PermissionOutletScreenState extends State<PermissionOutletScreen> {
  final search = TextEditingController();
  bool showSearchResult = false;

  String? name;
  String? getLocation;
  Position? position;
  Placemark? placemark;

  void getHistoryOutlet() {
    context.read<HistoryOutletBloc>().sendHistoryOutlet(context: context);
  }

  void getNama() async {
    name = await LocalStorage.getString("name");
    setState(() {});
  }

  void getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();
    await GetGeolocator()
        .getAddressLatLang(position!)
        .then((value) => {placemark = value});
  }

  @override
  void initState() {
    super.initState();
    getHistoryOutlet();
    getNama();
    getCurrentLocation();
    checkConnectivityAndNavigate();
  }

  void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.showNoInternetDialog(context, () {});
        ConnectivityHelper.hideNoInternetDialog();
        Navigator.pop(context);
      });
    });
  }

  @override
  void dispose() {
    ConnectivityHelper.dispose();
    super.dispose();
    search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final searchController = Get.put(SearchHistoryGetx());
    return Scaffold(
        appBar: GradientAppBar(
          title: Text(
            "Riwayat Absen",
            style: standarWhiteTextB,
          ),
        ),
        body: BlocBuilder<HistoryOutletBloc, HistoryOutletState>(
          builder: (context, stateOutlet) {
            if (stateOutlet is HistoryOutletSuccessLoad) {
              return stateOutlet.data.isNotEmpty
                  ? SingleChildScrollView(
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF1C4966),
                                              width: 2)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF1C4966))),
                                      // suffixIcon: const Icon(Icons.search,
                                      //     color: Color(0xFF1C4966)),
                                      hintText: "Search",
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.search,
                                        color: Color(0xFF1C4966)),
                                    onPressed: () {
                                      setState(() {
                                        searchController.onChangeSearchNew(
                                            search.text.toString(), () {
                                          setState(() {
                                            showSearchResult = true;
                                          });
                                        });
                                        // searchController.onChangeSearch();
                                        // search.text.toString();
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
                                  const SizedBox(
                                height: 10,
                              ),
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
                                return searchController.dataResult.isNotEmpty
                                    ? Column(children: [
                                        GestureDetector(
                                            onTap: () {
                                              ConnectivityHelper.dispose();
                                              // Get.to(SubmitAbsenceScreen(
                                              //   // distance: stateOutlet.data[i].dista,
                                              //   toko: outlet.customerName,
                                              //   alamat: outlet.address,
                                              //   latToko: outlet.latitude,
                                              //   longToko: outlet.longitude,
                                              //   customerId: outlet.customerId,
                                              // ));
                                              Get.off(PermissionScreen(
                                               customerId: outlet.customerId,
                                                customerName:
                                                    outlet.customerName,
                                              ));
                                            },
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: ListTile(
                                                    leading: const Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.home,
                                                          color: Colors.black,
                                                        )
                                                      ],
                                                    ),
                                                    subtitle: Text(
                                                      outlet.address.toString(),
                                                      style: smallBlackText,
                                                    ),
                                                    title: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          outlet.customerName
                                                              .toString(),
                                                          style: largeBlackText,
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          outlet.customerId
                                                              .toString(),
                                                          style: smallBlackText,
                                                        ),
                                                      ],
                                                    ))))
                                      ])
                                    : Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              ConnectivityHelper.dispose();
                                              Get.to(PermissionScreen(
                                                customerId: outlet.customerId,
                                                customerName:
                                                    outlet.customerName,
                                              ));
                                            },
                                            child: Card(
                                              child: ListTile(
                                                leading: const Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.home,
                                                      color: Colors.black,
                                                    )
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
                                                      style: largeBlackText,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      outlet.customerId
                                                          .toString(),
                                                      style: smallBlackText,
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Text(
                                                  outlet.address.toString(),
                                                  style: smallBlackText,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Text(name!),
                                        ],
                                      );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  : SingleChildScrollView(
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF1C4966),
                                              width: 2)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF1C4966))),
                                      // suffixIcon: const Icon(Icons.search,
                                      //     color: Color(0xFF1C4966)),
                                      hintText: "Search",
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.search,
                                        color: Color(0xFF1C4966)),
                                    onPressed: () {
                                      setState(() {
                                        searchController.onChangeSearchNew(
                                            search.text.toString(), () {
                                          setState(() {
                                            showSearchResult = true;
                                          });
                                        });
                                        // searchController.onChangeSearch();
                                        // search.text.toString();
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
                                  const SizedBox(
                                height: 10,
                              ),
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
                                return searchController.dataResult.isNotEmpty
                                    ? Column(children: [
                                        GestureDetector(
                                            onTap: () {
                                              ConnectivityHelper.dispose();

                                              Get.off(PermissionScreen(
                                               customerId: outlet.customerId,
                                                customerName:
                                                    outlet.customerName,
                                              ));
                                            },
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: ListTile(
                                                    leading: const Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.home,
                                                          color: Colors.black,
                                                        )
                                                      ],
                                                    ),
                                                    subtitle: Text(
                                                      outlet.address.toString(),
                                                      style: smallBlackText,
                                                    ),
                                                    title: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          outlet.customerName
                                                              .toString(),
                                                          style: largeBlackText,
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          outlet.customerId
                                                              .toString(),
                                                          style: smallBlackText,
                                                        ),
                                                      ],
                                                    ))))
                                      ])
                                    : Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              ConnectivityHelper.dispose();
                                              Get.to(PermissionScreen(
                                               customerId: outlet.customerId,
                                                customerName:
                                                    outlet.customerName,
                                              ));
                                            },
                                            child: Card(
                                              child: ListTile(
                                                leading: const Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.home,
                                                      color: Colors.black,
                                                    )
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
                                                      style: largeBlackText,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      outlet.customerId
                                                          .toString(),
                                                      style: smallBlackText,
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Text(
                                                  outlet.address.toString(),
                                                  style: smallBlackText,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Text(name!),
                                        ],
                                      );
                              },
                            ),
                          )
                        ],
                      ),
                    );
            } else if (stateOutlet is HistoryOutletLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
