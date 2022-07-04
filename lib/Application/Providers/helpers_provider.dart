import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:online_order_shop_mobile/Application/Authentication/authentication_error_handler.dart';
import 'package:online_order_shop_mobile/Application/Authentication/authentication_helper.dart';
import 'package:online_order_shop_mobile/Application/Cart/cart_helper.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/DeliveryAddress/delivery_address.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/catalogue_model.dart';
import 'package:online_order_shop_mobile/Domain/Profile/profile_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Exceptions/server_exceptions.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';

import 'dart:developer' as dev;

class HelpersProvider with ChangeNotifier {
  late CatalogueHelper _catalogueHelper;
  late CartHelper _cartHelper;
  late ServicesProvider services;
  late DeliveryAddress _addressHelper;
  late AuthenticationHelper _authHelper;

  Future<bool> initApp() async {
    try {
      await Firebase.initializeApp();

      services = ServicesProvider();
      await services.initialiaze();

      await services.productDatabase.connect();

      _catalogueHelper = CatalogueHelper(CatalogueModel());

      await _catalogueHelper.initCategories();

      _cartHelper = CartHelper(notifyListeners);
      await _initProfile();

      await services.permissionsService.requestGpsPermission();
    } on LocalDatabaseNotFound catch (_) {
      throw LocalDatabaseNotFound();
    } catch (e) {
      dev.log(e.toString());
    }

    return true;
  }

  Future<void> _initProfile() async {
    ProfileModel profile = ProfileModel();
    await profile.loadProfile();
    _authHelper = AuthenticationHelper(
      profile,
      services.authenticationService,
      AuthenticationErrorHandler(),
    );

    _addressHelper = DeliveryAddress(profile.getAddress());
  }

  CatalogueHelper get catalogueHelper => _catalogueHelper;

  CartHelper get cartHelper => _cartHelper;
  DeliveryAddress get addressHelper => _addressHelper;

  AuthenticationHelper get authHelper => _authHelper;
}
