import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class SettingsHelper {
  GoogleSignInAccount? _account;

  late Map<String, String> _authHeaders;

  Future<void> googleSignIn() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/drive.appdata',
        'https://www.googleapis.com/auth/drive.file',
      ],
    );

    try {
      _account = await _googleSignIn.signIn();
      _authHeaders = await _account!.authHeaders;
    } catch (error) {
      print(error);
    }
  }

  //https://drive.google.com/file/d/{fileId}/view
}
