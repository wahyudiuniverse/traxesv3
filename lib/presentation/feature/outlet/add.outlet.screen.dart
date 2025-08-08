// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traxes/bloc/feature/outlet/outlet.bloc.dart';
import 'package:traxes/constant/screen/fake.gps.screen.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/model/outlet/submit.outlet.model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../constant/widget/custom.button.dart';

class AddOutletScreen extends StatefulWidget {
  final Position? position;
  final Placemark? placemark;
  final String? villageName;
  final String? villageId;
  final String? districtId;
  final String? cityId;
  final String? ownerName;
  final String? outletName;
  final String? numberOwner;

  const AddOutletScreen(
      {super.key,
      this.position,
      this.placemark,
      this.villageName,
      this.villageId,
      this.districtId,
      this.cityId,
      this.ownerName,
      this.outletName,
      this.numberOwner});

  @override
  State<AddOutletScreen> createState() => _AddOutletScreenState();
}

class _AddOutletScreenState extends State<AddOutletScreen> {
  File? imageToko;
  String? img64;
  String? bytes;
  Position? position;
  Placemark? placemark;
  String? villageName;
  String? villageId;
  String? districtId;
  String? cityId;
  String? selectedValue;
  String? address;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void getImageAbsence() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        maxHeight: 400,
        maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        imageToko = File(pickedFile.path);
        final bytes = imageToko!.readAsBytesSync();
        img64 = base64Encode(bytes);
      } else if (pickedFile == null) {
        EasyLoading.showError("Difoto dulu ya toko nya",
            duration: const Duration(seconds: 3));
      }
    });
  }

  Future<Position?> getCurrentLocation() async {
    return await GetGeolocator().getCurrentLocation();
  }

  RefreshController refreshController = RefreshController();

  void getInitLocation() async {
    widget.placemark == null
        ? "Refresh layar jika alamatnya kosong"
        : addressController.text = "${widget.placemark!.street}, "
            "${widget.placemark!.locality}, "
            "${widget.placemark!.subLocality}, "
            "${widget.placemark!.administrativeArea}, "
            "${widget.placemark!.postalCode}";
  }

  void getKota() async {
    widget.placemark == null
        ? "-"
        : cityController.text = "${widget.placemark!.administrativeArea}";
  }

  void getKecamatan() async {
    widget.placemark == null
        ? "-"
        : districtController.text = "${widget.placemark!.subLocality}";
  }

  final List<int> categoryValues = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  final Map<int, String> categoryMap = {
    1: 'HYPERMARKET',
    2: 'SUPERMARKET',
    3: 'MINIMARKET',
    4: 'PASAR',
    5: 'GROSIR',
    6: 'WARUNG',
    7: 'DC',
    8: 'RUMAH',
    9: 'WAREHOUSE',
    10: 'KANTOR'
  };

  Future<void> refresh() async {
    position = await GetGeolocator().getCurrentLocation();
    if (position != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          placemark = placemarks.first;
          // ignore: unnecessary_null_comparison
          if (addressController != null) {
            addressController.text =
                "${placemark!.street}, ${placemark!.locality}, ${placemark!.subLocality}, ${placemark!.administrativeArea}, ${placemark!.postalCode}";
            cityController.text = "${placemark!.administrativeArea}";
            districtController.text = "${placemark!.locality}";
          } else {
            if (kDebugMode) {
              print("addressController is null");
            }
          }
          refreshController.refreshCompleted();
        });
      } else if (position!.isMocked) {
        Get.offAll(const FakeGPSWarningScreen());
      }
    } else {
      refreshController.refreshFailed();
    }
  }

  final outletNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final numberOwnerController = TextEditingController();
  final addressController = TextEditingController();
  final villageNameController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    position = widget.position;
    placemark = widget.placemark;
    getCurrentLocation();
    getInitLocation();
    setState(() {
      getCurrentLocation();
      getInitLocation();
      getKota();
      getKecamatan();
      districtController.text;
      addressController.text;
      cityController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    outletNameController.dispose();
    ownerNameController.dispose();
    numberOwnerController.dispose();
    addressController.dispose();
    villageNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final searchController = Get.put(SearchVillageGetx());
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(
          "Tambah lokasi",
          style: standarWhiteTextB,
        ),
      ),
      body: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          enablePullUp: false,
          header: const WaterDropMaterialHeader(
            backgroundColor: Color(0xFF1C4966),
          ),
          onRefresh: refresh,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                floating: false,
                pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: InkWell(
                    onTap: () {
                      getImageAbsence();
                    },
                    child: imageToko == null
                        ? const Icon(
                            Icons.camera_alt,
                            size: 70,
                            color: Color(0x404D6633),
                          )
                        : Image.file(
                            imageToko!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 25, bottom: 8),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "* Pastikan posisi foto miring/landscape",
                                style: smallBlackTextB,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "* Informasi toko",
                                  style: smallColorFontGrey,
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: outletNameController,
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "This field is required";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: "Nama Toko / Lokasi / Outlet",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF1C4966)),
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: "Nama Toko / Lokasi / Outlet",
                                  hintStyle: smallColorFontGrey,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 8),
                        child: TextFormField(
                          controller: ownerNameController,
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                          decoration: InputDecoration(
                              labelText: "Nama Pemilik",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1C4966)),
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: "Nama Pemilik",
                              hintStyle: smallColorFontGrey,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 8),
                        child: TextFormField(
                          controller: numberOwnerController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Nomor Kontak Pemilik",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1C4966)),
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: "Nomor Kontak Pemilik",
                              hintStyle: smallColorFontGrey,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 8),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "* Alamat toko",
                                style: smallColorFontGrey,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              readOnly: true,
                              maxLines: 2,
                              controller: addressController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "harap isi alamatnya";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: "Alamat",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF1C4966)),
                                      borderRadius: BorderRadius.circular(20)),
                                  fillColor: const Color(0xFFD3D3D3),
                                  filled: true,
                                  hintText:
                                      "Jika alamat kosong tarik layar dari atas ke bawah untuk me refresh lokasi",
                                  hintStyle: smallColorFontGrey,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 8),
                              child: TextFormField(
                                controller: cityController,
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                decoration: InputDecoration(
                                    labelText: "Nama Kota",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF1C4966)),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: "Nama Kota",
                                    hintStyle: smallColorFontGrey,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "This field is required";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 8),
                              child: TextFormField(
                                controller: districtController,
                                onEditingComplete: () {
                                  FocusScope.of(context).nextFocus();
                                },
                                decoration: InputDecoration(
                                    labelText: "Nama kecamatan",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF1C4966)),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: "Nama Kecamatan",
                                    hintStyle: smallColorFontGrey,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "This field is required";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Card(
                              child: DropdownButtonFormField2<int>(
                                style: smallBlueText,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.house),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
                                  border: InputBorder.none,
                                ),
                                hint: Text('Pilih jenis toko',
                                    style: standarBlueTextB),
                                items: categoryValues.map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item,
                                    child: Text(
                                      categoryMap[item]!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Pilih kategori toko';
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
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: CustomButton(
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () async {
                                var connectivityResult = await Connectivity().checkConnectivity();

                              if (imageToko == null) {
                                EasyLoading.showError("Fotonya mana ? :( ",
                                    duration: const Duration(seconds: 3));
                              } else if (
                                connectivityResult.contains(ConnectivityResult.none)
                              ) {

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
                                        child:
                                            Text('OK', style: smallBlackText),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                              }else {
                                CoolAlert.show(
                                    confirmBtnColor: const Color(0xFF661C63),
                                    confirmBtnText: "Tambah lokasi",
                                    confirmBtnTextStyle: smallWhiteText,
                                    cancelBtnText: "Kembali",
                                    cancelBtnTextStyle: smallColorFontGrey,
                                    backgroundColor: const Color(0xFF661C63),
                                    animType: CoolAlertAnimType.slideInUp,
                                    title: "Anda yakin ingin menambah toko ?",
                                    titleTextStyle: standarBlackText,
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    onConfirmBtnTap: () {
                                      if (formKey.currentState!.validate() &&
                                          imageToko != null) {
                                        var data = SubmitOutletModel(
                                          districtId: districtController.text,
                                          cityId: cityController.text,
                                          villageId: 0,
                                          customerName:
                                              outletNameController.text,
                                          ownerName: ownerNameController.text,
                                          noContact: numberOwnerController.text,
                                          address: addressController.text,
                                          latitude:
                                              position!.latitude.toString(),
                                          longitude:
                                              position!.longitude.toString(),
                                          category: int.tryParse(
                                                  selectedValue.toString()) ??
                                              0,
                                          photo: img64,
                                        );
                                        context
                                            .read<OutletBloc>()
                                            .submitOutlet(data, context);
                                        GetGeolocator().getCurrentLocation();
                                        const Duration(seconds: 3);
                                      } else if (position!.isMocked) {
                                        const FakeGPSWarningScreen();
                                      }
                                    });
                              }
                            },
                            child: Text(
                              "Tambah toko",
                              style: standarWhiteText,
                            )),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
