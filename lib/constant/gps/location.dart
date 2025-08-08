import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:traxes/constant/screen/fake.gps.screen.dart';

class GetGeolocator {
  Future<Position?> getCurrentLocation() async {
    bool? serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

   Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high
   );

   if (position.isMocked) {
    Get.offAll(const FakeGPSWarningScreen());
   }

   return position;
  }

  Future<Placemark> getAddressLatLang(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return place;
  }
}
// 
//       currentAdress =
//           "${place.administrativeArea}, ${place.name}, ${place.street}";