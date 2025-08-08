// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:traxes/model/check_in/check.in.model.dart';
import 'package:traxes/presentation/user/permission/leave/search.leave.outlet.screen.dart';

class LeavePermissionScreen extends StatefulWidget {
  final String? customerId;
  final String? customerName;
  final String? latToko;
  final String? longToko;
  const LeavePermissionScreen(
      {super.key,
      this.customerId,
      this.customerName,
      this.latToko,
      this.longToko});

  @override
  State<LeavePermissionScreen> createState() => _LeavePermissionScreenState();
}

class _LeavePermissionScreenState extends State<LeavePermissionScreen> {
  File? imageAbsence;
  Position? position;
  String? bytes;
  double? distance;
  String? img64;

  String enteredText = "";
  String? selectedValue;
  String? selectedReason;

  final List<String> reasonItems = [
    'Menikah',
    'Melahirkan',
    'Khitanan',
    'Kedukaan',
    'Pemerintah',
    'Lain-lain'
  ];

  final keteranganController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  Future<void> getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Submit Izin Cuti", style: standarWhiteTextB),
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
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const LeaveOutletScreen());
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
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Card(
                      child: DropdownButtonFormField2<String>(
                        style: smallBlueText,
                        isExpanded: true,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.next_week),
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            border: InputBorder.none
                            // Add more decoration..
                            ),
                        hint:
                            Text('Pilih alasan cuti', style: standarBlueTextB),
                        items: reasonItems
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Pilih alasan cuti';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value.toString();
                          });
                        },
                        onSaved: (value) {
                          selectedValue = value.toString();
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: TextFormField(
                                        validator: (v) {
                                          if (v!.isEmpty) {
                                            return "Isi dulu alasan cuti nya disini";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: keteranganController,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(250)
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
                                                    BorderRadius.circular(20)),
                                            hintText: "Maksimal 250 karakter",
                                            hintStyle: smallColorFontGrey,
                                            counterStyle: enteredText.length ==
                                                    250
                                                ? extraSmallBlackText.copyWith(
                                                    color:
                                                        const Color(0xFFFF5050))
                                                : extraSmallWhiteText.copyWith(
                                                    color: Colors.grey),
                                            counterText:
                                                "${enteredText.length.toString()} / 250",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
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
                                                    "Ambil foto form cuti",
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
                                            confirmBtnText: "Ajukan cuti",
                                            confirmBtnTextStyle: smallWhiteText,
                                            cancelBtnText: "Kembali",
                                            cancelBtnTextStyle:
                                                smallColorFontGrey,
                                            backgroundColor:
                                                const Color(0xFFFFFFFF),
                                            animType:
                                                CoolAlertAnimType.slideInUp,
                                            title:
                                                "Yakin mau cuti sekarang ? Pastikan alasan dan fotonya jelas ya :)",
                                            titleTextStyle: standarBlackText,
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            onConfirmBtnTap: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                var emp = stateEmployee.data[0];
                                                var data = CheckInV2Model(
                                                    employeeId: emp.employeeId,
                                                    dateCio: currentDate,
                                                    datetimephoneIn: dateTime,
                                                    keterangan:
                                                        keteranganController
                                                            .text,
                                                    projectId: int.parse(emp
                                                        .projectId
                                                        .toString()),
                                                    distanceIn: 0.0,
                                                    radiusIn: 0,
                                                    statusEmp: 4,
                                                    jabatanId: 5,
                                                    reason: selectedValue,
                                                    customerId: widget
                                                        .customerId,
                                                    latitudeIn:
                                                        position!
                                                            .latitude
                                                            .toString(),
                                                    longitudeIn: position!
                                                        .longitude
                                                        .toString(),
                                                    fotoIn: img64);
                                                context
                                                    .read<PermissionBloc>()
                                                    .leavePermission(
                                                        data, context);
                                              }
                                            });
                                      }
                                    },
                                    child: Text(
                                      "Ajukan cuti",
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
