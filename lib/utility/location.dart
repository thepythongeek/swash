import 'package:geolocator/geolocator.dart';

class LocationError implements Exception {
  String msg;

  LocationError({required this.msg});

  @override
  String toString() {
    return msg;
  }
}

Future<Position> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error(LocationError(msg: 'Location services not enabled'));
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error(LocationError(msg: 'Permission denied'));
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        LocationError(msg: 'Location permissions denied permanently'));
  }
  return await Geolocator.getCurrentPosition();
}
