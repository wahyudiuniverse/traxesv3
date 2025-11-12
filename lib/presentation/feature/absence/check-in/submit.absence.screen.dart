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
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/absence/check_in/checkin.bloc.dart';
import 'package:traxes/bloc/absence/check_radius/check.radius.bloc.dart';
import 'package:traxes/bloc/absence/project_radius/project.radius.bloc.dart';
import 'package:traxes/bloc/absence/project_radius/project.radius.state.dart';
import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/constant/screen/fake.gps.screen.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/screen/success.checkin.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:image/image.dart' as img;
import 'package:traxes/model/check_in/check.in.model.dart';

class SubmitAbsenceScreen extends StatefulWidget {
  final String? alamat;
  final String? toko;
  final String? projectId;
  final String? customerId;
  final String? latToko;
  final String? longToko;

  const SubmitAbsenceScreen({
    super.key,
    this.alamat,
    this.toko,
    this.projectId,
    this.customerId,
    this.latToko,
    this.longToko,
  });

  @override
  State<SubmitAbsenceScreen> createState() => _SubmitAbsenceScreenState();
}

class _SubmitAbsenceScreenState extends State<SubmitAbsenceScreen> {
  Uint8List? imgBytes;
  Uint8List? watermarkedImgBytes;
  Position? position;
  double? currentDistanceIn;
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
  String dateTime = DateTime.now().toString();
  String? projectid = "0";
  String? selectedValue;
  Uint8List? compressImage;

  final Map<int, String> transportMap = {
    1: 'Dalam kota (Kendaraan pribadi)',
    2: 'Luar kota (Kendaraan pribadi)',
    3: 'Luar kota (Transportasi umum) / (Sewa kendaraan)'
  };

  final List<int> transportValues = [1, 2, 3];

  final RefreshController refreshController = RefreshController();

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
      setState(() {
        imgBytes = Uint8List.fromList(watermarkedImgBytes);
      });
    }
  }

  void callProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      projectid = prefs.getString("emp_project").toString();
    });
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
    // if (position!.isMocked) {
    //   Get.offAll(const FakeGPSWarningScreen());
    // }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    compressImage = Uint8List(0);
    callProject();
    context.read<ProjectRadiusBloc>().getProjectRadius(context: context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Submit Check-in", style: standarWhiteTextB),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropMaterialHeader(
          backgroundColor: Color(0xFF1C4966),
        ),
        onRefresh: () async {
          getCurrentLocation();
          refreshController.refreshCompleted();
        },
        child: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, stateEmployee) {
            if (stateEmployee is EmployeeLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: SafeArea(
                        child: Column(
                          children: [
                            ListView.builder(
                              itemCount: stateEmployee.data.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var employee = stateEmployee.data[0];
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 15,
                                      top: 25,
                                      bottom: 8,
                                      right: isPortrait ? 15 : 25),
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
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: ClipOval(
                                              child: Image.asset(
                                                "assets/images/blue-person.png",
                                                color: Colors.white,
                                                width: 90,
                                                height: 90,
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
                                              Text(
                                                employee.fullname.toString(),
                                                style: standarWhiteText,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: Text(
                                                  "NIP: ${employee.employeeId.toString()}",
                                                  style: standarWhiteText,
                                                ),
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
                            Padding(
                              padding: EdgeInsets.only(
                                  right: isPortrait ? 12 : 25,
                                  left: isPortrait ? 12 : 12),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SizedBox(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "DETAIL CUSTOMER",
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
                                          child: Text(
                                            widget.toko!,
                                            style: largeBlackTextB,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            widget.alamat!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: smallColorFontGrey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, top: 5),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            currentDate,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: smallColorFontGrey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            tdata,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: smallColorFontGrey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Jarak: ${position != null ? Geolocator.distanceBetween(double.parse(widget.latToko!), double.parse(widget.longToko!), position!.latitude, position!.longitude).toStringAsFixed(2) : 'sedang mengkalkulasikan'} meter',
                                            style: smallColorFontGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            projectid == "49"
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 15),
                                    child: Card(
                                      child: DropdownButtonFormField2<int>(
                                        style: smallBlueText,
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.bus_alert),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          border: InputBorder.none,
                                        ),
                                        hint: Text('Pilih jenis transport',
                                            style: standarBlueTextB),
                                        items: transportValues.map((item) {
                                          return DropdownMenuItem<int>(
                                            value: item,
                                            child: Text(
                                              transportMap[item]!,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          );
                                        }).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Pilih Transport';
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
                                          icon: Icon(Icons.arrow_drop_down,
                                              color: Colors.black45),
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
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: Get.width / 2.2,
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
                                                ),
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
                                  SizedBox(
                                    width: 170,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF1C4966),
                                      ),
                                      onPressed: getImageAbsence,
                                      child: Text("Ambil Foto",
                                          style: smallWhiteText),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: const Color(0xFF1C4966),
                        ),
                        onPressed: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();

                          if (imgBytes == null) {
                            EasyLoading.showError("Selfie dulu dong :(",
                                duration: const Duration(seconds: 3));
                            return;
                          } else if (position == null) {
                            EasyLoading.showError(
                                "Jarak belum tersedia, tunggu sampai jarak muncul",
                                duration: const Duration(seconds: 3));
                          } else if (projectid == "49" &&
                              selectedValue == null) {
                            EasyLoading.showError("Wajib isi pilihan transport",
                                duration: const Duration(seconds: 3));
                          } 
                          // else if (position!.isMocked) {
                          //   Get.offAll(const FakeGPSWarningScreen());
                          // } 
                          else if (currentDistanceIn == null) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: 'Error',
                              text:
                                  'Failed to calculate the distance. Please try again.',
                              confirmBtnColor: Colors.red,
                            );
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
                                          Navigator.of(context).pop();
                                        },
                                        child:
                                            Text('OK', style: smallBlackText),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            CoolAlert.show(
                              confirmBtnColor: const Color(0xFF661C63),
                              confirmBtnText: "Check-in sekarang",
                              confirmBtnTextStyle: smallWhiteText,
                              cancelBtnText: "Kembali",
                              cancelBtnTextStyle: smallColorFontGrey,
                              backgroundColor: const Color(0xFF661C63),
                              animType: CoolAlertAnimType.slideInUp,
                              title: "Anda yakin ingin Check-in sekarang?",
                              titleTextStyle: standarBlackText,
                              context: context,
                              type: CoolAlertType.confirm,
                              onConfirmBtnTap: () async {
                                var projectRadiusState =
                                    context.read<ProjectRadiusBloc>().state;
                                if (projectRadiusState
                                    is ProjectRadiusSuccess) {
                                  int radius = int.parse(
                                    projectRadiusState.data[0].projectRadius
                                        .toString(),
                                  );

                                  var distance = Geolocator.distanceBetween(
                                    double.parse(widget.latToko.toString()),
                                    double.parse(widget.longToko.toString()),
                                    double.parse(position!.latitude.toString()),
                                    double.parse(
                                        position!.longitude.toString()),
                                  );


                                  var longitudeToko = widget.longToko;
                                  var latitudeToko = widget.latToko;
                                  var emp = stateEmployee.data[0];
                                  String base65 = base64Encode(imgBytes!);

                                  var data = CheckInV2Model(
                                    employeeId: emp.employeeId.toString(),
                                    customerId: widget.customerId,
                                    projectId:
                                        int.parse(emp.projectId.toString()),
                                    datetimephoneIn: dateTime,
                                    dateCio: currentDate,
                                    jabatanId: 5,
                                    radiusIn: radius,
                                    latitudeIn: position!.latitude.toString(),
                                    longitudeIn: position!.longitude.toString(),
                                    distanceIn: distance,
                                    fotoIn: base65.toString(),
                                    statusEmp: 1,
                                    statusTransport: int.tryParse(
                                            selectedValue.toString()) ??
                                        0,
                                    updateToko: 0,
                                  );

                                  if (distance < radius) {
                                    // Inside the radius, proceed with check-in
                                    context
                                        .read<SubmitCheckInBloc>()
                                        .submitCheckIn(
                                          context: context,
                                          formData: data,
                                          latitudeToko: latitudeToko.toString(),
                                          longitudeToko:
                                              longitudeToko.toString(),
                                          onSuccess: () {
                                            Get.off(SuccessScreen(
                                              name: emp.fullname,
                                              toko: widget.toko,
                                              alamat: widget.alamat,
                                              currentDate: currentDate,
                                              tdata: tdata,
                                              watermarkedImgBytes: imgBytes!,
                                              jabatan: emp.typeId == null
                                                  ? ""
                                                  : emp.typeId.toString(),
                                            ));
                                          },
                                        );
                                    GetGeolocator().getCurrentLocation();

                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        "customerName", widget.toko.toString());
                                    prefs.setString("customerId",
                                        widget.customerId.toString());
                                    prefs.setString(
                                        "address", widget.alamat.toString());
                                    prefs.setString("latitudeToko",
                                        position!.latitude.toString());
                                    prefs.setString("longitudeToko",
                                        position!.longitude.toString());
                                  } else {
                                  
                                    context.read<CheckRadiusBloc>().checkRadius(
                                          context,
                                          widget.customerId,
                                          widget.toko,
                                          radius.toString(),
                                          data,
                                          latitudeToko,
                                          longitudeToko,
                                          emp.fullname.toString(),
                                          emp.typeId.toString(),
                                          widget.toko!,
                                          widget.alamat!,
                                          currentDate,
                                          tdata,
                                          imgBytes!,
                                        );
                                    GetGeolocator().getCurrentLocation();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        "customerName", widget.toko.toString());
                                    prefs.setString("customerId",
                                        widget.customerId.toString());
                                    prefs.setString(
                                        "address", widget.alamat.toString());
                                    prefs.setString("latitudeToko",
                                        position!.latitude.toString());
                                    prefs.setString("longitudeToko",
                                        position!.longitude.toString());
                                  }
                                } else {
                                  // Handle error when the radius is not loaded
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    title: "Error",
                                    text:
                                        "Unable to fetch the project radius. Please try again.",
                                    confirmBtnText: "Kembali",
                                    onConfirmBtnTap: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                }
                              },
                            );
                          }
                        },
                        child: Text("Submit absen", style: smallWhiteText),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
