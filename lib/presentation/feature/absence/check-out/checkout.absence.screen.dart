// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/absence/check_out/checkout.bloc..dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/constant/screen/fake.gps.screen.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/screen/success.checkout.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:image/image.dart' as img;
import 'package:image_watermark/image_watermark.dart';
import 'package:traxes/model/check_out/check.out.model.dart';

class CheckOutAbsenceScreen extends StatefulWidget {
  final String? alamat;
  final String? toko;
  final String? projectId;
  final String? customerId;
  final String? latToko;
  final String? longToko;

  const CheckOutAbsenceScreen(
      {super.key,
      this.alamat,
      this.toko,
      this.projectId,
      this.customerId,
      this.latToko,
      this.longToko});

  @override
  State<CheckOutAbsenceScreen> createState() => _CheckOutAbsenceScreenState();
}

class _CheckOutAbsenceScreenState extends State<CheckOutAbsenceScreen> {
  Uint8List? imgBytes;
  Uint8List? watermarkedImgBytes;
  Position? position;
  bool isLoading = false;
  String? bytes;
  double? distance;
  XFile? pickedFile;
  double? currentDistanceIn;
  String? projectId;
  String? selectedValue;
  String? selectedReason;
  String? projectid = "0";

  final List<String> reasonItems = [
    'STOCK OPNAME',
    'TIDAK CUKUP WAKTU',
    'PERBANTUAN TOKO LAIN',
    'TOKO TUTUP SEMENTARA',
    'TOKO TUTUP PERMANEN',
    'AUDIT HO',
    'MEETING',
    'EMERGENCY (SAKIT, KECELAKAAN, DLL)',
    'FORCE MAJOR (GEMPA BUMI, BANJIR, DLL)',
    'VERIFIKASI RETUR',
    'PERSONIL VACANT'
  ];

  void calculateDistanceIn() {
    if (widget.latToko != null && widget.longToko != null && position != null) {
      currentDistanceIn = Geolocator.distanceBetween(
          double.parse(widget.latToko!),
          double.parse(widget.longToko!),
          position!.latitude,
          position!.longitude);
    }
  }

  void callProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      projectId = prefs.getString("emp_project").toString();
    });
  }

  void getImageAbsence() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (pickedImage != null) {
      final t = await pickedImage.readAsBytes();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var nip = prefs.getString("empid");
      final watermarkedImgBytes = await ImageWatermark.addTextWatermark(
        imgBytes: t,
        watermarkText:
            " $nip \n ${widget.toko.toString()} \n $currentDate \n $tdata",
        font: img.arial_14,
        color: Colors.white,
        dstX: 15,
        dstY: 300,
      );

//show foto
      setState(() {
        imgBytes = Uint8List.fromList(watermarkedImgBytes);
      });

//second compress
    }
  }

  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  String dateTime = DateTime.now().toString();

  void getEmployee() async {
    context.read<EmployeeBloc>().employeeLoad();
  }

  Future<void> getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();
    calculateDistanceIn();
    // if (position!.isMocked) {
    //   Get.off(const FakeGPSWarningScreen());
    // }
  }

  @override
  void initState() {
    super.initState();
    callProject();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      getCurrentLocation().then((value) => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Submit Check-out", style: standarWhiteTextB),
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
                            top: 20,
                            right: 20,
                            left: 15,
                            bottom: 15,
                          ),
                          child: Card(
                            color: const Color(0xFF1C4966),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF661C63),
                                    Color(0xFF1C4966),
                                  ],
                                ),
                              ),
                              child: SizedBox(
                                width: 150,
                                height: MediaQuery.of(context).size.height / 8,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: SizedBox(
                                        child: ClipOval(
                                          child: Image.asset(
                                            "assets/images/blue-person.png",
                                            color: Colors.white,
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12, left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SizedBox(
                              width: Get.width - 35,
                              height: Get.height / 4,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "CUSTOMER",
                                        style: standarColoredTextB,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(widget.toko!,
                                          style: standarBlackTextB),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(widget.alamat!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: smallColorFontGrey),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 5),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(currentDate,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: smallColorFontGrey),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(tdata,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: smallColorFontGrey),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Jarak: ${currentDistanceIn?.toStringAsFixed(2) ?? 'sedang mengkalkulasikan'} meter',
                                        style: smallColorFontGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          projectId == "38"
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 15),
                                  child: Card(
                                    child: DropdownButtonFormField2<String>(
                                      style: smallBlueText,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.remove_shopping_cart),
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        border: InputBorder.none,
                                      ),
                                      hint: Text('Pilih reason toko',
                                          style: standarBlueTextB),
                                      items: reasonItems.map((item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Pilih Reason';
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.black26),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      getImageAbsence();
                                    },
                                    child: imgBytes == null
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
                                        : Image.memory(
                                            imgBytes!,
                                            width: 170,
                                            height: 170,
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: SizedBox(
                              width: 170,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1C4966),
                                ),
                                onPressed: () {
                                  getImageAbsence();
                                },
                                child: Text(
                                  "Ambil Foto",
                                  style: smallWhiteText,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                alignment: Alignment.center,
                                backgroundColor: const Color(0xFF1C4966),
                              ),
                              onPressed: () async {
                                var distance = Geolocator.distanceBetween(
                                  double.parse(widget.latToko.toString()),
                                  double.parse(widget.longToko.toString()),
                                  double.parse(position!.latitude.toString()),
                                  double.parse(position!.longitude.toString()),
                                );
                                int radius = 500;

                                var connectivityResult =
                                    await Connectivity().checkConnectivity();
                                if (distance > radius && projectId == "47") {
                                  EasyLoading.showError(
                                      "Jarak anda 500 meter dari toko!",
                                      duration: const Duration(seconds: 3));
                                } else {
                                   if (imgBytes == null) {
                                  EasyLoading.showError(
                                      "Periksa foto dan foto watermark kembali",
                                      duration: const Duration(seconds: 3));
                                } else if (connectivityResult
                                    .contains(ConnectivityResult.none)) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return PopScope(
                                        canPop: false,
                                        child: AlertDialog(
                                          title: Text('No Internet Connection',
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
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Check-out sekarang",
                                    confirmBtnTextStyle: smallWhiteText,
                                    cancelBtnText: "Kembali",
                                    cancelBtnTextStyle: smallColorFontGrey,
                                    backgroundColor: const Color(0xFF661C63),
                                    animType: CoolAlertAnimType.slideInUp,
                                    title:
                                        "Anda yakin ingin Check-out sekarang ?",
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    onConfirmBtnTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      // if (position!.isMocked) {
                                      //   Get.offAll(
                                      //       const FakeGPSWarningScreen());
                                      // }

                                      var longitudeToko = widget.longToko;
                                      var latitudeToko = widget.latToko;
                                      var emp = stateEmployee.data[0];
                                      String base65 = base64Encode(imgBytes!);

                                      var data = CheckOutModel(
                                          employeeId: emp.employeeId,
                                          customerId: widget.customerId,
                                          dateCio: currentDate,
                                          datetimephoneOut: dateTime,
                                          radiusOut: radius,
                                          distanceOut: distance,
                                          latitudeOut:
                                              position!.latitude.toString(),
                                          longitudeOut:
                                              position!.longitude.toString(),
                                          fotoOut: base65.toString(),
                                          statusToko: selectedValue);
                                      if (imgBytes != null) {
                                        prefs.remove("check_order");
                                        prefs.remove("order");
                                        prefs.remove("check_stock");
                                        prefs.remove("stock");
                                        context
                                            .read<SubmitCheckOutBloc>()
                                            .submitCheckOut(
                                                context: context,
                                                formData: data,
                                                latitudeToko:
                                                    latitudeToko.toString(),
                                                longitudeToko:
                                                    longitudeToko.toString(),
                                                onSuccess: () {
                                                  Get.offAll(SuccessOutScreen(
                                                      toko: widget.toko,
                                                      alamat: widget.alamat,
                                                      currentDate: currentDate,
                                                      tdata: tdata,
                                                      watermarkedImgBytes:
                                                          imgBytes!,
                                                      name: emp.fullname,
                                                      jabatan:
                                                          emp.typeId == null
                                                              ? ""
                                                              : emp.typeId
                                                                  .toString()));
                                                });

                                        GetGeolocator().getCurrentLocation();
                                      } else {
                                        EasyLoading.showError(
                                            "Periksa foto dan foto watermark kembali",
                                            duration:
                                                const Duration(seconds: 3));
                                      }
                                    },
                                  );
                                }
                                }

                               
                              },
                              child: Text(
                                "Submit Check-out",
                                style: smallWhiteText,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1C4966)),
                backgroundColor: Colors.white,
              ),
            );
          }
        },
      ),
    );
  }
}
