import 'package:flutter/widgets.dart';
import 'package:online_order_shop_mobile/Application/DeliveryAddress/latlng.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/GpsLocation/address.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:provider/provider.dart';

class DeliveryAddress {
  final Address _address;

  DeliveryAddress(this._address);

  Future<bool> initGpsLocation() async {
    await ServicesProvider().permissionsService.requestGpsPermission();
    await _address.getDeviceLocation();
    return true;
  }

  LatLng getLocation() {
    return _address.getCoordinates();
  }

  void setLocation(
      {required double latitude,
      required double longitude,
      required String infos}) {
    _address.updateAddress(infos: infos);
    _address.updateCoordinates(latitude: latitude, longitude: longitude);
  }

  String getAddress() {
    return _address.getAddress();
  }

  Future<void> requestGpsPermissions(BuildContext context) async {
    ServicesProvider().permissionsService.requestGpsPermission().then((value) {
      if (value) {
        Navigator.pop(context);
        Provider.of<NavigationProvider>(context, listen: false)
            .navigateToDeliveryAddressScreen(context, () {}, replace: false);
      }
    });
  }
}
