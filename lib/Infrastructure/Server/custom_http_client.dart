import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class GoogleHttpClient extends IOClient {
  final Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) async =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) async =>
      super.head(url, headers: headers!..addAll(_headers));
}
