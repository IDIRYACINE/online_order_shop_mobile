import 'package:online_order_shop_mobile/Infrastructure/Permissions/ipermissions_service.dart';
import 'package:geolocator/geolocator.dart';

class PermissionsService implements IPermissionsService {
  @override
  Future<bool> requestGpsPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}
