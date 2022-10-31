//
import 'package:earnlia/core/services/cache.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

class UserLocation {
  Future<void> getLocation() async {
    Location location = Location();

    late bool serviceEnabled;
    late PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await location.getLocation();

    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        locationData.latitude!, locationData.longitude!);

    Cache.setData(key: 'location', value: placemarks[0].isoCountryCode!);
  }
}
