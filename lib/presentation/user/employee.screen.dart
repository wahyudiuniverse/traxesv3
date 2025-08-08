// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/bloc/user/version/version.bloc.dart';
import 'package:traxes/bloc/user/version/version.state.dart';
import 'package:traxes/constant/util/check.intenet.dart';
import 'package:traxes/constant/widget/card.dart';
import 'package:traxes/constant/screen/download.sku.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/screen/warning.screen.dart';
import 'package:traxes/presentation/dashboard/dashboard.screen.dart';
import 'package:traxes/presentation/history/history_absence/history.absence.dart';
import 'package:traxes/presentation/history/history_order/history.order.dart';
import 'package:traxes/presentation/user/permission/main.permission.screen.dart';
import 'package:traxes/presentation/user/activity.screen.dart';
import 'package:traxes/presentation/user/login.employee.screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailEmployeeScreen extends StatefulWidget {
  final String? nik;

  const DetailEmployeeScreen({super.key, this.nik});

  @override
  State<DetailEmployeeScreen> createState() => _DetailEmployeeScreenState();
}

class _DetailEmployeeScreenState extends State<DetailEmployeeScreen> {
  String? nik;
  String? nama;
  String? versionApp;
  String greeting = '';
  bool isDialogShown = false;

  void callNik() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nik = prefs.getString("empid");
    });
  }

  Future<void> fullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString("nama");
    });
  }

  void getEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    context.read<EmployeeBloc>().employeeLoad();
    setState(() {
      nik = prefs.getString("empid");
    });
  }

    void checkConnectivityAndNavigate() {
    ConnectivityHelper.checkConnectivity(context, () {

      setState(() {
        ConnectivityHelper.hideNoInternetDialog();
      });
    });
  }

  void getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;

    setState(() {
      versionApp = version;
    });
    context.read<VersionBloc>().sendVersion(version: versionApp.toString(), context: context);
  }

  void setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = 'Selamat Pagi';
    } else if (hour < 17) {
      greeting = 'Selamat Siang';
    } else {
      greeting = 'Selamat Malam';
    }
  }

  @override
  void initState() {
    super.initState();
    callNik();
    getEmployee();
    fullName();
    getAppVersion();
    setGreeting();
    checkConnectivityAndNavigate();
  }

  @override
  void dispose() {
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final totalGrid = isLandscape && screenWidth > 700 ? 3 : 2;

    return Scaffold(
      appBar: GradientAppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "$greeting, $nama",
            style: smallWhiteTextB,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, stateEmployee) {
                  if (stateEmployee is EmployeeLoaded) {
                    return Column(
                      children: [
                        ListView.builder(
                          itemCount: stateEmployee.data.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, i) {
                            var employee = stateEmployee.data[i];
                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF661C63),
                                    Color(0xFF1C4966),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: ClipOval(
                                          child: Image.asset(
                                            "assets/images/blue-person.png",
                                            color: Colors.white,
                                            width: isLandscape ? 150 : 90,
                                            height: isLandscape ? 150 : 90,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            employee.employeeId.toString(),
                                            style: standarWhiteText,
                                          ),
                                          Text(
                                            employee.typeId.toString(),
                                            style: standarWhiteText,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                        GridView.count(
                          crossAxisCount: totalGrid,
                          primary: false,
                          shrinkWrap: true,
                          children: [
                            buildMenuCard(
                              onTap: () {
                                Get.to(const PermissionMainScreen());
                              },
                              icon: Icons.person_off,
                              text: "Absensi / Off",
                              textColor: smallWhiteText,
                              color: const Color(0xFF1C4963),
                            ),
                            buildMenuCard(
                              onTap: () {
                                Get.offAll(EmployeeScreen(nik: nik));
                              },
                              icon: FontAwesomeIcons.personRunning,
                              text: "Aktifitas",
                              textColor: smallWhiteText,
                              color: const Color(0xFF1C4966),
                            ),
                            buildMenuCard(
                              onTap: () {
                                Get.to(const DashboardScreen());
                              },
                              icon: FontAwesomeIcons.personCircleCheck,
                              text: "Profile",
                              textColor: smallWhiteText,
                              color: const Color(0xFFF28C28),
                            ),
                            buildMenuCard(
                              onTap: () {
                                Get.to(const HistoryAbsenceScreen());
                              },
                              icon: Icons.history,
                              text: "Riwayat Absen",
                              textColor: smallWhiteText,
                              color: const Color(0xFF135C51),
                            ),
                            buildMenuCard(
                              onTap: () {
                                Get.to(const DownloadSkuScreen());
                              },
                              icon: Icons.download,
                              text: "Download Material",
                              textColor: smallWhiteText,
                              color: const Color(0xFF097969),
                            ),
                            buildMenuCard(
                              onTap: () {
                                Get.to(const HistoryOrderScreen());
                              },
                              icon: Icons.history_edu_sharp,
                              text: "Riwayat Sell Out",
                              textColor: smallWhiteText,
                              color: const Color(0xFF661C63),
                            ),
                          ],
                        ),
                        Text(
                          "Versi aplikasi: ${versionApp.toString()}",
                          style: smallBlackText,
                        ),
                      ],
                    );
                  } else if (stateEmployee is EmployeeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          WarningScreen(
                            buttonText: "Kembali ke halaman login",
                            warningText:
                                "NIP dan NAMA anda belum terdaftar di sistem atau Anda mengganti handphone, hubungi ADMIN",
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              Get.offAll(const LoginEmployeeScreen());
                            },
                            icon: Icons.warning,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              BlocBuilder<VersionBloc, VersionState>(
                builder: (context, state) {
                  if (state is UpdateNotification && !isDialogShown) {
                    isDialogShown = true; 
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Update Available'),
                              content: Text(state.message),
                              actions: [
                                TextButton(
                                  child: const Text('Later'),
                                  onPressed: () {
                                    isDialogShown = false; // Reset the flag
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Update Now'),
                                  onPressed: () async {
                                    const url =
                                        'https://play.google.com/store/apps/details?id=id.cakrawala.traxes';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                    isDialogShown = false; // Reset the flag
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
