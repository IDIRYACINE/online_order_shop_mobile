import 'package:geolocator/geolocator.dart';

import '../../Application/DeliveryAddress/latlng.dart';

class Address {
  late String _address;
  final LatLng _latlng = LatLng(0, 0);

  Address([String? address, double? latitude, double? longitude]) {
    _address = address ?? "";
    _latlng.latitude = latitude ?? 0;
    _latlng.longitude = longitude ?? 0;
  }

  /// Request device location.handle GPS permission issues
  Future<bool> getDeviceLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    _latlng.latitude = position.latitude;
    _latlng.longitude = position.longitude;
    _address = "bloc C";
    return true;
  }

  /// Return address aditional infos
  /// Example : door number 10 , bloc A
  String getAddress() {
    return _address;
  }

  /// Return address location on map as GPS coordinates
  LatLng getCoordinates() {
    return _latlng;
  }

  /// Update address location on map
  void updateCoordinates(
      {required double latitude, required double longitude}) {
    _latlng.latitude = latitude;
    _latlng.longitude = longitude;
  }

  /// Update associated address infos
  void updateAddress({required String infos}) {
    _address = infos;
  }
}
