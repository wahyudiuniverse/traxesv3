// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/bloc/user/permission/permission.bloc.dart';
import 'package:traxes/constant/screen/fake.gps.screen.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/model/check_in/check.in.model.dart';
import 'package:traxes/presentation/user/permission/permission/search.outlet.permission.screen.dart';


class PermissionScreen extends StatefulWidget {
  final String? customerId;
  final String? customerName;
  const PermissionScreen({super.key, this.customerId, this.customerName});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  File? imageAbsence;
  Position? position;
  String? bytes;
  String? img64;
  String? latToko;
  String? longToko;
  String enteredText = "";

  final keteranganController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getImageAbsence() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imageAbsence = File(pickedFile.path);
        final bytes = imageAbsence!.readAsBytesSync();
        img64 = base64Encode(bytes);
      } else if (pickedFile == null) {
        EasyLoading.showError("Selfie dulu dong");
      }
    });
  }

  void getLatToko() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      latToko = prefs.getString("latitudeToko").toString();
    });
  }

  void getLongToko() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      longToko = prefs.getString("longitudeToko").toString();
    });
  }

  getImage() async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Pilih sumber foto",
          style: mediumBlackTextB,
          textAlign: TextAlign.center,
        ),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C4966),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                "Kamera",
                style: smallWhiteText,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C4966),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Galeri",
                style: smallWhiteText,
              ),
            ),
          ],
        ),
      ),
    );

    if (isCamera == null) return;

    XFile? file = await ImagePicker()
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    imageAbsence = File(file!.path);
    final bytes = imageAbsence!.readAsBytesSync();
    img64 = base64Encode(bytes);
    setState(() {});
  }

  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  String dateTime = DateTime.now().toString();

  void getEmployee() async {
    context.read<EmployeeBloc>().employeeLoad();
  }

  Future<void> getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();
    // if (position!.isMocked) {
    //   Get.offAll(const FakeGPSWarningScreen());
    // }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      getCurrentLocation().then((value) => setState(() {}));
      getLatToko();
      getLongToko();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Submit Izin", style: standarWhiteTextB),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, stateEmployee) {
          if (stateEmployee is EmployeeLoaded) {
            return SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                children: [
                  ListView.builder(
                    itemCount: stateEmployee.data.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: ((context, index) {
                      var employee = stateEmployee.data[0];
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 20, right: 20, left: 15, bottom: 15),
                        child: Card(
                            color: const Color(0xFF1C4966),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              width: 150,
                              height: Get.height / 8,
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: ClipOval(
                                      child: Image.asset(
                                          "assets/images/blue-person.png",
                                          width: 90,
                                          height: 90),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 15),
                                        child: Text(
                                          employee.fullname.toString(),
                                          style: standarWhiteText,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 15),
                                        child: Text(
                                          "NIP :  ${employee.employeeId.toString()}",
                                          style: standarWhiteText,
                                        ),
                                      ),
                                    ]),
                              ]),
                            )),
                      );
                    }),
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color(0xFF1C4966)
                  //   ),
                  //     onPressed: () {
                  //       Get.to(const PermissionOutletScreen());
                  //     },
                  //     child: const Text("Pilih lokasi")),

                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const PermissionOutletScreen());
                      },
                      child: Card(
                        child: ListTile(
                          leading: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_pin),
                            ],
                          ),
                          title: Text(
                            widget.customerName != null
                                ? widget.customerName.toString()
                                : "Pilih lokasi terlebih dahulu",
                            style: standarBlueTextB,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 15),
                    child: Form(
                      key: formKey,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 20, left: 15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: TextFormField(
                                          validator: (v) {
                                            if (v!.isEmpty) {
                                              return "Isi dulu alasan izin nya...";
                                            } else {
                                              return null;
                                            }
                                          },
                                          controller: keteranganController,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                250)
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              enteredText = value;
                                            });
                                          },
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF1C4966)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              hintText: "Maksimal 250 karakter",
                                              hintStyle: smallColorFontGrey,
                                              counterStyle: enteredText.length ==
                                                      250
                                                  ? extraSmallBlackText
                                                      .copyWith(
                                                          color: const Color(
                                                              0xFFFF5050))
                                                  : extraSmallWhiteText
                                                      .copyWith(
                                                          color: Colors.grey),
                                              counterText:
                                                  "${enteredText.length.toString()} / 250",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10.0),
                                        width: Get.width / 2.2,
                                        height: 160,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.black26),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: InkWell(
                                          onTap: () {
                                            getImage();
                                          },
                                          child: imageAbsence == null
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.camera_alt,
                                                      size: 70,
                                                      color: Color(0x404D6633),
                                                    ),
                                                    Text(
                                                      "Selfie dulu yuk...",
                                                      style: smallColorFontGrey,
                                                    )
                                                  ],
                                                )
                                              : Image.file(
                                                  imageAbsence!,
                                                  width: 170,
                                                  height: 170,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF1C4966)),
                                        onPressed: () {
                                          getImage();
                                        },
                                        child: Text(
                                          "Ambil Foto",
                                          style: smallWhiteTextB,
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  height: 90,
                                ),
                                SizedBox(
                                  width: Get.width,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          alignment: Alignment.center,
                                          backgroundColor:
                                              const Color(0xFF1C4966)),
                                      onPressed: () async {
                                        var connectivityResult =
                                            await Connectivity()
                                                .checkConnectivity();
                                        if (imageAbsence == null) {
                                          EasyLoading.showError(
                                              "Selfie nya mana? :(",
                                              duration:
                                                  const Duration(seconds: 3));
                                        } else if (connectivityResult.contains(
                                            ConnectivityResult.none)) {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return PopScope(
                                                canPop: false,
                                                child: AlertDialog(
                                                  title: Text(
                                                      'No Internet Connection',
                                                      style: largeBlackText),
                                                  content: Text(
                                                      'Please check your internet connection and try again.',
                                                      style: standarBlackText),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('OK',
                                                          style:
                                                              smallBlackText),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          CoolAlert.show(
                                              confirmBtnColor:
                                                  const Color(0xFF661C63),
                                              confirmBtnText: "Ajukan izin",
                                              confirmBtnTextStyle:
                                                  smallWhiteText,
                                              cancelBtnText: "Kembali",
                                              cancelBtnTextStyle:
                                                  smallColorFontGrey,
                                              backgroundColor:
                                                  const Color(0xFFFFFFFF),
                                              animType:
                                                  CoolAlertAnimType.slideInUp,
                                              title:
                                                  "Izin sekarang ? Pastikan alasan dan fotonya jelas ya :)",
                                              titleTextStyle: standarBlackText,
                                              context: context,
                                              type: CoolAlertType.confirm,
                                              onConfirmBtnTap: () {
                                                if (formKey.currentState!
                                                        .validate() &&
                                                    imageAbsence != null) {
                                                  var emp =
                                                      stateEmployee.data[0];
                                                  int radius = 50;
                                                  var data = CheckInV2Model(
                                                      employeeId:
                                                          emp.employeeId,
                                                      dateCio: currentDate,
                                                      datetimephoneIn: dateTime,
                                                      keterangan:
                                                          keteranganController
                                                              .text,
                                                      projectId: int.parse(emp
                                                          .projectId
                                                          .toString()),
                                                      distanceIn: 0.0,
                                                      radiusIn: radius,
                                                      statusEmp: 2,
                                                      jabatanId: 5,
                                                      customerId:
                                                          widget.customerId,
                                                      latitudeIn: position!
                                                          .latitude
                                                          .toString(),
                                                      longitudeIn: position!
                                                          .longitude
                                                          .toString(),
                                                      fotoIn: img64);
                                                  context
                                                      .read<PermissionBloc>()
                                                      .sendPermission(
                                                          data, context);
                                                }
                                              });
                                        }
                                      },
                                      child: Text(
                                        "Ajukan Permohonan Izin",
                                        style: smallWhiteTextB,
                                      )),
                                )
                              ])),
                    ),
                  )
                ],
              )),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
