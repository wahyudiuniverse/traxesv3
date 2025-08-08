// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, duplicate_ignore

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/constant/widget/card.dart';
// import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/screen/visit.screen.dart';
import 'package:traxes/presentation/dashboard/dashboard.screen.dart';
import 'package:traxes/presentation/feature/biils/bills.screen.dart';
import 'package:traxes/presentation/feature/competitor/competitor.screen.dart';
import 'package:traxes/presentation/feature/display/display.screen.dart';
import 'package:traxes/presentation/feature/display_mbd/admin/verify.mbd.screen.dart';
import 'package:traxes/presentation/feature/display_mbd/SMD/display.mbd.screen.dart';
import 'package:traxes/presentation/feature/outlet/add.outlet.screen.dart';
import 'package:traxes/presentation/feature/planogram/planogram.screen.dart';
import 'package:traxes/presentation/feature/price_tag/price.tag.screen.dart';
import 'package:traxes/presentation/feature/sku/order.main.screen.dart';
import 'package:traxes/presentation/feature/stock_product/stock.main.screen.dart';

class EmployeeScreen extends StatefulWidget {
  final String? nik;
  const EmployeeScreen({super.key, this.nik});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String? nik;
  Position? position;
  Placemark? placemark;
  String? customerName;
  String? customerId;
  String? address;
  String? jabatan;

  Future<void> getPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.denied) {
      return;
    }
  }

  void callJabatan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jabatan = prefs.getString("jabatan").toString();
    });
  }

  void callNik() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nik = prefs.getString("empid").toString();
    });
  }

  void getCustomerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerName = prefs.getString("customerName").toString();
    });
  }

  void getCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getString("customerId").toString();
    });
  }

  void getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString("address").toString();
    });
  }

  getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();
    await GetGeolocator()
        .getAddressLatLang(position!)
        .then((value) => {placemark = value});
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
    callNik();
    getCurrentLocation();
    getCustomerName();
    getAddress();
    getCustomerId();
    getPermission();
    callJabatan();
    placemark;
  }

  void getEmployee() async {
    context.read<EmployeeBloc>().employeeLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
            child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 20, bottom: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF661C63), // Deep purple
                    Color(0xFF1C4966), // Dark pink
                  ],
                ), // AppBar background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(onTap: () {
                    Get.to(const DashboardScreen());
                  },  child:  const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white)), // Left icon
                  Text(
                    'Aktivitas',
                    style: standarWhiteTextB
                  ),
                  const Icon(Icons.notifications, color: Colors.white), // Right icon
                ],
              ),
            ),
            BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, stateEmployee) {
                if (stateEmployee is EmployeeLoaded) {
                  return Column(children: [
                    InkWell(
                      // onTap: () {
                      //   Get.offAll(const DashboardScreen());
                      // },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListView.builder(
                          itemCount: stateEmployee.data.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, i) {
                            var employee = stateEmployee.data[0];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(
                                          0xFF661C63), // Start color (vibrant purple)
                                      Color(0xFF1C4966), // End color
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/blue-person.png",
                                      color: Colors.white,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            employee.fullname.toString(),
                                            style: smallWhiteText,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            employee.employeeId.toString(),
                                            style: standarWhiteText,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            employee.typeId.toString(),
                                            style: standarWhiteText,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            customerName != null &&
                                                    customerName!.isNotEmpty
                                                ? customerName!
                                                : "",
                                            style: smallWhiteText,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      children: [
                        buildMenuCard(
                            onTap: () {
                              Get.to(const VisitScreen());
                            },
                            icon: FontAwesomeIcons.fingerprint,
                            text: "Check-in/out",
                            color: const Color(0xFF50C878),
                            textColor: smallWhiteText),
                        buildMenuCard(
                            onTap: () {
                              Get.to(AddOutletScreen(
                                position: position,
                                placemark: placemark,
                              ));
                            },
                            icon: FontAwesomeIcons.shop,
                            text: "Tambah Lokasi",
                            color: const Color(0xFFF4C430),
                            textColor: smallWhiteText),
                        buildMenuCard(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var checkCheckin = prefs.getInt("getIn");

                              if (checkCheckin != 1) {
                                // ignore: use_build_context_synchronously
                                CoolAlert.show(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    title: "Check-in terlebih dahulu",
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Kembali",
                                    confirmBtnTextStyle: smallWhiteText,
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.error);
                              } else {
                                Get.to(const OrderMainScreen());
                              }
                            },
                            icon: FontAwesomeIcons.cartShopping,
                            text: "Order/Sell-out",
                            color: const Color(0xFFE3735E),
                            textColor: smallWhiteText),
                        buildMenuCard(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var checkCheckin = prefs.getInt("getIn");

                              if (checkCheckin != 1) {
                                // ignore: use_build_context_synchronously
                                CoolAlert.show(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    title: "Check-in terlebih dahulu",
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Kembali",
                                    confirmBtnTextStyle: smallWhiteText,
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.error);
                              } else {
                                Get.to(const StockMainScreen());
                              }
                            },
                            icon: FontAwesomeIcons.boxesStacked,
                            text: "Stock/Sell-in",
                            color: const Color(0xFF702963),
                            textColor: smallWhiteText),
                        buildMenuCard(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var checkCheckin = prefs.getInt("getIn");

                              if (checkCheckin != 1) {
                                // ignore: use_build_context_synchronously
                                CoolAlert.show(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    title: "Check-in terlebih dahulu",
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Kembali",
                                    confirmBtnTextStyle: smallWhiteText,
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.error);
                              } else {
                                if (jabatan == "ADMIN" ||
                                    jabatan == "ADMIN PROJECT") {
                                  Get.to(const VerifyMbdScreen());
                                } else {
                                  Get.to(DisplayMbdScreen(
                                    customerName: customerName,
                                    address: address,
                                    customerId: customerId,
                                  ));
                                }
                              }
                            },
                            icon: FontAwesomeIcons.table,
                            text:
                                jabatan == "ADMIN" || jabatan == "ADMIN PROJECT"
                                    ? "Verifikasi MBD"
                                    : "Display MBD",
                            color: const Color(0xFF242375),
                            textColor: smallWhiteText),
                        buildMenuCard(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var checkCheckin = prefs.getInt("getIn");

                              if (checkCheckin != 1) {
                                // ignore: use_build_context_synchronously
                                CoolAlert.show(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    title: "Check-in terlebih dahulu",
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Kembali",
                                    confirmBtnTextStyle: smallWhiteText,
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.error);
                              } else {
                                Get.to(BillsScreen(
                                  customerName: customerName,
                                  address: address,
                                  customerId: customerId,
                                ));
                              }
                            },
                            icon: FontAwesomeIcons.paperclip,
                            text: "Struk",
                            color: const Color(0xFFAA336A),
                            textColor: smallWhiteText),
                        buildMenuCard(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var checkCheckin = prefs.getInt("getIn");

                              if (checkCheckin != 1) {
                                // ignore: use_build_context_synchronously
                                CoolAlert.show(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    title: "Check-in terlebih dahulu",
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Kembali",
                                    confirmBtnTextStyle: smallWhiteText,
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.error);
                              } else {
                                Get.to(DisplayScreen(
                                  customerName: customerName,
                                  address: address,
                                  customerId: customerId,
                                ));
                              }
                            },
                            icon: FontAwesomeIcons.table,
                            text: "Display",
                            color: const Color(0xFF008080),
                            textColor: smallWhiteText),
                        buildMenuCard(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var checkCheckin = prefs.getInt("getIn");

                              if (checkCheckin != 1) {
                                // ignore: use_build_context_synchronously
                                CoolAlert.show(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    title: "Check-in terlebih dahulu",
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Kembali",
                                    confirmBtnTextStyle: smallWhiteText,
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.error);
                              } else {
                                Get.to(PlanogramScreen(
                                  customerName: customerName,
                                  address: address,
                                  customerId: customerId,
                                ));
                              }
                            },
                            icon: FontAwesomeIcons.tablet,
                            text: "Planogram",
                            color: const Color(0xFF436EA2),
                            textColor: smallWhiteText),
                        buildMenuCard(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var checkCheckin = prefs.getInt("getIn");

                              if (checkCheckin != 1) {
                                // ignore: use_build_context_synchronously
                                CoolAlert.show(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    title: "Check-in terlebih dahulu",
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Kembali",
                                    confirmBtnTextStyle: smallWhiteText,
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.error);
                              } else {
                                Get.to(PriceTagScreen(
                                  customerName: customerName,
                                  address: address,
                                  customerId: customerId,
                                ));
                              }
                            },
                            icon: FontAwesomeIcons.tag,
                            text: "Price Tag",
                            color: const Color(0xFF40B5AD),
                            textColor: smallWhiteText),
                        buildMenuCard(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var checkCheckin = prefs.getInt("getIn");

                              if (checkCheckin != 1) {
                                // ignore: use_build_context_synchronously
                                CoolAlert.show(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    title: "Check-in terlebih dahulu",
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Kembali",
                                    confirmBtnTextStyle: smallWhiteText,
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.error);
                              } else {
                                Get.to(CompetitorScreen(
                                  customerName: customerName,
                                  address: address,
                                  customerId: customerId,
                                ));
                              }
                            },
                            icon: FontAwesomeIcons.triangleExclamation,
                            text: "Kompetitor",
                            color: const Color(0xFF800020),
                            textColor: smallWhiteText),
                      ],
                    ),
                  ]);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
