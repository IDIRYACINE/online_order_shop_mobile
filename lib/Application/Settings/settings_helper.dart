import 'package:google_sign_in/google_sign_in.dart';

import 'package:online_order_shop_mobile/Application/ImagePicker/image_picker_helper.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/custom_http_client.dart';
import 'dart:developer' as dev;

class SettingsHelper {
  GoogleSignInAccount? _account;

  late ImagePicker _imagePicker;

  late Map<String, String> _authHeaders;

  Future<void> googleSignIn() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/drive',
      ],
    );

    try {
      _account = await _googleSignIn.signIn();
      _authHeaders = await _account!.authHeaders;
      _imagePicker = ImagePicker(GoogleHttpClient(_authHeaders));
    } catch (error) {
      dev.log(error.toString());
    }
  }

  ImagePicker getImagePicker() {
    return _imagePicker;
  }

  //https://drive.google.com/file/d/{fileId}/view
}
