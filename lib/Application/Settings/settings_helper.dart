import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import 'package:online_order_shop_mobile/Application/ImagePicker/image_picker_helper.dart'
    as my_app;
import 'package:online_order_shop_mobile/Infrastructure/Server/custom_http_client.dart';
import 'dart:developer' as dev;

class SettingsHelper {
  GoogleSignInAccount? _account;

  GoogleSignIn? _googleSignIn;

  bool _connected = false;

  late DriveApi _driveApi;

  late my_app.ImagePicker _imagePicker;

  late Map<String, String> _authHeaders;

  Future<void> googleSignIn(VoidCallback onConnect) async {
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/drive',
      ],
    );

    try {
      _account = await _googleSignIn!.signIn();
      _authHeaders = await _account!.authHeaders;
      _driveApi = DriveApi(GoogleHttpClient(_authHeaders));
      _imagePicker = my_app.ImagePicker(_driveApi);
      _connected = true;
      onConnect();
    } catch (error) {
      dev.log(error.toString());
    }
  }

  my_app.ImagePicker getImagePicker() {
    return _imagePicker;
  }

  bool isConnected() {
    return _connected;
  }

  Future<void> uploadImages(BuildContext context) async {
    FilePicker imagePicker = FilePicker.platform;

    FilePickerResult? files = await imagePicker.pickFiles(withReadStream: true);

    if (files != null) {
      try {
        await _imagePicker.uploadImages(files.files);
      } catch (e) {
        dev.log(e.toString());
      }
    }
  }

  void signOut() {
    if (_googleSignIn == null) {
      return;
    }
    _googleSignIn!.disconnect();
  }
}
