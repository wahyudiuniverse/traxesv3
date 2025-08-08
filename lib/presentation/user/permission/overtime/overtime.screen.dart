// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/bloc/user/permission/permission.bloc.dart';
import 'package:traxes/constant/screen/fake.gps.screen.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/model/overtime/overtime.dart';
import 'package:traxes/presentation/user/permission/overtime/search.overtime.outlet.screen.dart';

class OvertimeScreen extends StatefulWidget {
  final String? customerId;
  final String? customerName;
  final String? latToko;
  final String? longToko;

  const OvertimeScreen(
      {super.key,
      this.customerId,
      this.customerName,
      this.latToko,
      this.longToko});

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  File? imageAbsence;
  Position? position;
  String? bytes;
  double? distance;
  String? img64;
  double? currentDistanceIn;

  final keteranganController = TextEditingController();
  final dateController = TextEditingController();
  final timeInController = TextEditingController();
  final dateOutController = TextEditingController();
  final timeOutController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  getImage() async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Pilih sumber foto kamu",
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
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400
        );
        
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

  void calculateDistanceIn() {
    if (widget.latToko != null && widget.longToko != null && position != null) {
      currentDistanceIn = Geolocator.distanceBetween(
          double.parse(widget.latToko!),
          double.parse(widget.longToko!),
          position!.latitude,
          position!.longitude);
    }
  }

  Future<void> getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();
    calculateDistanceIn();
    if (position!.isMocked) {
      Get.offAll(const FakeGPSWarningScreen());
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      getCurrentLocation().then((value) => setState(() {}));
    });
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    keteranganController.dispose();
    dateOutController.dispose();
    timeInController.dispose();
    timeOutController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Submit Lembur", style: standarWhiteTextB),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const OvertimeOutletScreen());
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
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          dateController.text =
                              DateFormat("yyyy-MM-dd").format(pickedDate);
                        }
                      },
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF1C4966)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Tanggal masuk",
                        hintStyle: smallColorFontGrey,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      controller: timeInController,
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          // Convert TimeOfDay to DateTime
                          DateTime selectedTime = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              pickedTime.hour,
                              pickedTime.minute);

                          // Format selected time
                          String formattedTime =
                              DateFormat('HH:mm:ss').format(selectedTime);

                          setState(() {
                            timeInController.text =
                                formattedTime;
                          });
                        }
                      },
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF1C4966)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Jam masuk",
                        hintStyle: smallColorFontGrey,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      controller: dateOutController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          dateOutController.text =
                              DateFormat("yyyy-MM-dd").format(pickedDate);
                        }
                      },
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF1C4966)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Tanggal keluar",
                        hintStyle: smallColorFontGrey,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      controller: timeOutController,
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          // Convert TimeOfDay to DateTime
                          DateTime selectedTime = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              pickedTime.hour,
                              pickedTime.minute);

                          // Format selected time
                          String formattedTime =
                              DateFormat('HH:mm:ss').format(selectedTime);

                          setState(() {
                            timeOutController.text =
                                formattedTime; // Set the value of text field.
                          });
                        }
                      },
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "This field is required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF1C4966)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Jam Keluar",
                        hintStyle: smallColorFontGrey,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 20, left: 15),
                      child: Form(
                        key: formKey,
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
                                                    "Ambil foto form lembur",
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
                                      } else if (connectivityResult
                                          .contains(ConnectivityResult.none)) {
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
                                                        style: smallBlackText),
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
                                            confirmBtnText: "Ajukan Lembur",
                                            confirmBtnTextStyle: smallWhiteText,
                                            cancelBtnText: "Kembali",
                                            cancelBtnTextStyle:
                                                smallColorFontGrey,
                                            backgroundColor:
                                                const Color(0xFFFFFFFF),
                                            animType:
                                                CoolAlertAnimType.slideInUp,
                                            title: "Ajukan lembur?",
                                            titleTextStyle: standarBlackText,
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            onConfirmBtnTap: () {
                                              String dateOut = dateOutController
                                                  .text; // Get the date string
                                              String timeOut =
                                                  timeOutController.text;

                                              DateTime dateTimeOut =
                                                  DateTime.parse(
                                                      '$dateOut $timeOut');

                                              if (img64 == null) {
                                                EasyLoading.showError(
                                                    "Selfie dulu dong :(",
                                                    duration: const Duration(
                                                        seconds: 3));
                                                return;
                                              }

                                              if (position!.isMocked) {
                                                Get.offAll(
                                                    const FakeGPSWarningScreen());
                                              }
                                              var distance = Geolocator
                                                  .distanceBetween(
                                                      double
                                                          .parse(widget.latToko
                                                              .toString()),
                                                      double
                                                          .parse(widget.longToko
                                                              .toString()),
                                                      double.parse(position!
                                                          .latitude
                                                          .toString()),
                                                      double.parse(position!
                                                          .longitude
                                                          .toString()));

                                              if (formKey.currentState!
                                                      .validate() &&
                                                  distance < 500) {
                                                var emp = stateEmployee.data[0];
                                                var data = OvertimeModel(
                                                    employeeId: emp.employeeId,
                                                    dateCio: currentDate,
                                                    datetimephoneIn: dateTime,
                                                    keterangan:
                                                        keteranganController
                                                            .text,
                                                    projectId: emp.projectId,
                                                    distanceIn: distance,
                                                    radiusIn: 500,
                                                    customerId: widget
                                                        .customerId,
                                                    latitudeIn: position!
                                                        .latitude
                                                        .toString(),
                                                    longitudeIn:
                                                        position!
                                                            .longitude
                                                            .toString(),
                                                    latitudeOut:
                                                        position!
                                                            .latitude
                                                            .toString(),
                                                    longitudeOut:
                                                        position!
                                                            .longitude
                                                            .toString(),
                                                    distanceOut: distance,
                                                    datetimephoneOut:
                                                        dateTimeOut.toString(),
                                                    radiusOut: 500,
                                                    fotoIn: img64);
                                                context
                                                    .read<PermissionBloc>()
                                                    .overTime(data, context);
                                              } else if (imageAbsence == null) {
                                              } else {
                                                EasyLoading.showError(
                                                    "Pastikan jarak anda dibawah 500 Meter dengan toko",
                                                    duration: const Duration(
                                                        seconds: 3));
                                              }
                                            });
                                      }
                                    },
                                    child: Text(
                                      "Ajukan Lembur",
                                      style: smallWhiteText,
                                    )),
                              )
                            ]),
                      ))
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
