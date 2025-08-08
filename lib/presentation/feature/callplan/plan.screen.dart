import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:traxes/bloc/user/callplan/callplan.bloc.dart';
import 'package:traxes/bloc/user/callplan/callplan.state.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/sharedprefs.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/screen/warning.screen.dart';
import 'package:traxes/presentation/feature/absence/check-in/submit.absence.screen.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {

  String? name;
  String? getLocation;
  Position? position;
  Placemark? placemark;

  void getCallPlan() {
    context.read<CallplanBloc>().getCallPlan();
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
    getCurrentLocation();
    getNama();
    getCallPlan();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text(
        "Lokasi CallPlan",
        style: standarWhiteText,
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF1C4966),
    ),
    body: BlocBuilder<CallplanBloc, CallplanState>(
      builder: (context, stateCallPlan) {
        if (stateCallPlan is CallplanLoaded) {
          return SingleChildScrollView(
            child: ListView.builder(
              itemCount: stateCallPlan.data.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var callPlan = stateCallPlan.data[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(SubmitAbsenceScreen(
                          toko: callPlan.customerName,
                          alamat: callPlan.address,
                          latToko: callPlan.latitude,
                          longToko: callPlan.longitude,
                          customerId: callPlan.customerId,
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 15),
                        child: Card(
                          child: ListTile(
                            leading: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home,
                                  color: Colors.black,
                                )
                              ],
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  callPlan.customerName.toString(),
                                  style: largeBlackText,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  callPlan.customerId.toString(),
                                  style: smallBlackText,
                                ),
                              ],
                            ),
                            subtitle: Text(
                              callPlan.address.toString(),
                              style: smallBlackText,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WarningScreen(
                  
                  warningText: "Harap pilih menu visit",
                  icon: Icons.warning,
                  buttonText: "Kembali ke menu awal",
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          );
        }
      },
    ),
  );
  }
}
