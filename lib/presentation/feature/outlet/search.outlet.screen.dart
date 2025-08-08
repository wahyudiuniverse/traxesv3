// import 'package:cool_alert/cool_alert.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:traxes/constant/location.dart';
// import 'package:traxes/constant/text.style.dart';
// import 'package:traxes/getx/search.village.controller.dart';
// import 'package:traxes/presentation/outlet/add.outlet.screen.dart';

// class SearchOutletScreen extends StatefulWidget {
//   final String? outletName;
//   final String? ownerName;
//   final String? numberOwner;

//   const SearchOutletScreen({super.key, this.outletName, this.ownerName, this.numberOwner});

//   @override
//   State<SearchOutletScreen> createState() => _SearchOutletScreenState();
// }

// class _SearchOutletScreenState extends State<SearchOutletScreen> {
//   Position? position;
//   Placemark? placemark;

//   void getCurrentLocation() async {
//     position = await GetGeolocator().getCurrentLocation();
//     await GetGeolocator()
//         .getAddressLatLang(position!)
//         .then((value) => {placemark = value});
//   }

//   final search = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//        WidgetsBinding.instance.addPostFrameCallback((_) {
//       CoolAlert.show(
//         context: context,
//         type: CoolAlertType.loading,
//         text: "Loading...",
//         textTextStyle: mediumBlackText
//         );
//     });
    
//     Future.delayed(const Duration(milliseconds: 800), () {
//       Navigator.of(context).pop(); // Close the loading alert
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final searchController = Get.put(SearchVillageGetx());
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//             child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                   left: 15, right: 15, top: 10, bottom: 5),
//               child: TextFormField(
//                 controller: search,
//                 onChanged: (value) async {
//                   searchController.search = value.toString();
//                   await searchController
//                       .onChangeSearchVillage()
//                       .then((value) => setState(() {}));
//                 },
//                 decoration: InputDecoration(
//                     hintText: "Cari alamat desa disini",
//                     hintStyle: smallColorFontGrey,
//                     suffixIcon: const Icon(Icons.search),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15))),
//               ),
//             ),
//             searchController.search.isEmpty
//                 ? const SizedBox()
//                 : GetBuilder<SearchVillageGetx>(
//                     builder: (searchController) => Padding(
//                       padding:
//                           const EdgeInsets.only(top: 25, left: 15, right: 15),
//                       child: ListView.builder(
//                         itemCount: searchController.dataResult.length < 30
//                             ? searchController.dataResult.length
//                             : 30,
//                         shrinkWrap: true,
//                         physics: const BouncingScrollPhysics(),
//                         itemBuilder: (context, i) {
//                           var village = searchController.dataResult[i];
//                           return Column(
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   // Get.to(SubmitAbsenceScreen(
//                                   //   toko: outlet.customerName,
//                                   //   alamat: outlet.address,
//                                   //   latToko: outlet.latitude,
//                                   //   longToko: outlet.longitude,
//                                   //   customerId: outlet.customerId,
//                                   // ));
//                                   Get.to(AddOutletScreen(
//                                     position: position,
//                                       villageName: village.villageName,
//                                       villageId: village.villId,
//                                       cityId: village.cityId,
//                                       districtId: village.distId,
//                                       placemark: placemark,
//                                       ownerName: widget.ownerName,
//                                       outletName: widget.outletName,
//                                       numberOwner: widget.numberOwner,
//                                       ));
//                                 },
//                                 child: Card(
//                                   child: ListTile(
//                                     leading: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: const [
//                                         Icon(
//                                           Icons.home,
//                                           color: Colors.black,
//                                         )
//                                       ],
//                                     ),
//                                     title: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           village.villageName.toString(),
//                                           style: largeBlackText,
//                                         ),
//                                         const SizedBox(
//                                           height: 10,
//                                         ),
//                                         Text(
//                                           village.villId.toString(),
//                                           style: smallBlackText,
//                                         ),
//                                       ],
//                                     ),
//                                     subtitle: Text(
//                                       village.cityId.toString(),
//                                       style: smallBlackText,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // Text(name!),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//           ],
//         )),
//       ),
//     );
//   }
// }