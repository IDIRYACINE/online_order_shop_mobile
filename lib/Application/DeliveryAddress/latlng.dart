import 'package:latlong2/latlong.dart' as customlat;

class LatLng {
  late final customlat.LatLng _latLng;

  LatLng(double latitude, double longitude) {
    _latLng = customlat.LatLng(latitude, longitude);
  }

  double get latitude => _latLng.latitude;
  double get longitude => _latLng.longitude;

  customlat.LatLng get instance => _latLng;

  set latitude(double value) {
    _latLng.latitude = value;
  }

  set longitude(double value) {
    _latLng.longitude = value;
  }
}
