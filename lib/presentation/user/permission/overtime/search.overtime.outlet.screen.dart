import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:traxes/bloc/history/history_outlet/history.outlet.bloc.dart';
import 'package:traxes/bloc/history/history_outlet/history.outlet.state.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/sharedprefs.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/getx/search_history.controller.dart';
import 'package:traxes/presentation/user/permission/overtime/overtime.screen.dart';

class OvertimeOutletScreen extends StatefulWidget {
  const OvertimeOutletScreen({super.key});

  @override
  State<OvertimeOutletScreen> createState() => _OvertimeOutletScreenState();
}

class _OvertimeOutletScreenState extends State<OvertimeOutletScreen> {
  final search = TextEditingController();
  bool showSearchResult = false;

  String? name;
  String? getLocation;
  Position? position;
  Placemark? placemark;

  void getHistoryOutlet() {
    context.read<HistoryOutletBloc>().sendHistoryOutlet(context: context);
  }
void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {
      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
        Get.back();
      });
    });
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

  @override
  void dispose() {
    super.dispose();
    search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(SearchHistoryGetx());
    return Scaffold(
        appBar: GradientAppBar(
        title: Text(
            "Pilih toko/lokasi lembur",
            style: standarWhiteTextB,
          ),
        ),
        body: BlocBuilder<HistoryOutletBloc, HistoryOutletState>(
          builder: (context, stateOutlet) {
            if (stateOutlet is HistoryOutletSuccessLoad) {
              return SingleChildScrollView(
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
                              // onChanged: (value) async {
                              //   searchController.search = value.toString();
                              //   await searchController
                              //       .onChangeSearch()
                              //       .then((value) => setState(() {}));
                              // },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF1C4966), width: 2)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
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
                      padding:
                          const EdgeInsets.only(top: 25, left: 15, right: 15),
                      child: ListView.builder(
                        itemCount: showSearchResult
                            ? searchController.dataResult.length
                            : stateOutlet.data.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          dynamic outlet = searchController.dataResult.isEmpty
                              ? stateOutlet.data[i]
                              : searchController.dataResult[i];
                          return searchController.dataResult.isEmpty
                              ? Column(children: [
                                  GestureDetector(
                                      onTap: () {
                                        Get.to(OvertimeScreen(
                                          // distance: stateOutlet.data[i].dista,
                                          customerName: outlet.customerName,
                                          latToko: outlet.latitude,
                                          longToko: outlet.longitude,
                                          customerId: outlet.customerId,
                                        ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                          
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
                                                subtitle: Text(
                                                  outlet.address.toString(),
                                                  style: smallBlackText,
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
                                                ))),
                                      ))
                                ])
                              : Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(OvertimeScreen(
                                          customerName: outlet.customerName,
                                          latToko: outlet.latitude,
                                          longToko: outlet.longitude,
                                          customerId: outlet.customerId,
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
                                                outlet.customerName.toString(),
                                                style: largeBlackText,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                outlet.customerId.toString(),
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
            } else {
              return const Center(child: Text("Kosong"));
            }
          },
        ));
  }
}
