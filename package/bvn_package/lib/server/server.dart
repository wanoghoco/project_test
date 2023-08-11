import 'dart:convert' as convert;
import 'package:bvn_selfie/app_data_helper.dart';
import 'package:dio/dio.dart' as di;
import "package:http/http.dart" as http;

class Server {
  final String key;
  final bool isFull;
  final Function(bool)? onFinishDownload;
  Map<String, String>? header;
  final int timeout;
  static http.Client client = http.Client();
  static bool forceLogout = false;
  static const String _mainBaseUrl = "https://baas.getraventest.com";
  static const String _baseUrl = "$_mainBaseUrl/apps/";

  /// base class for making http request[Server]
  Server(
      {required this.key,
      this.timeout = 55,
      this.isFull = false,
      this.onFinishDownload,
      this.header});

  ///call method to make a http request using get method [getRequest]
  ///it returns a list with the first element being the body while the last element is the response code
  Future<dynamic> getRequest() async {
    try {
      return await client
          .get(Uri.parse(isFull ? key : _baseUrl + key),
              headers: await _getHeader())
          .then((response) async {
        if (response.statusCode == 406) {}

        if (response.body.isEmpty) {
          return "oops, something went wrong...";
        }

        return convert.jsonDecode(response.body);
      }).timeout(Duration(seconds: timeout), onTimeout: () {
        return "failed";
      });
    } catch (ex) {
      return "failed";
    } finally {}
  }

  ///call method to make a http request using post method [postRequest]
  ///it returns a list with the first element being the body while the last element is the response code
  Future<dynamic> postRequest(Map<String, dynamic> body) async {
    try {
      return await client
          .post(Uri.parse(isFull ? key : _baseUrl + key),
              body: convert.json.encode(body), headers: await _getHeader())
          .then((response) {
        if (response.statusCode == 406) {}
        return convert.jsonDecode(response.body);
      }).timeout(Duration(seconds: timeout), onTimeout: () {
        return "failed";
      });
    } catch (ex) {
      return "failed";
    } finally {}
  }

  Future<dynamic> putRequest(Map body) async {
    try {
      return await client
          .put(Uri.parse(isFull ? key : _baseUrl + key),
              body: convert.json.encode(body), headers: await _getHeader())
          .then((response) {
        if (response.statusCode == 406) {}
        return convert.jsonDecode(response.body);
      }).timeout(Duration(seconds: timeout), onTimeout: () {
        return "failed";
      });
    } catch (ex) {
      return "failed";
    } finally {}
  }

  Future<dynamic> deleteRequest(Object body) async {
    try {
      return await client
          .delete(Uri.parse(isFull ? key : _baseUrl + key),
              body: convert.jsonEncode(body), headers: await _getHeader())
          .then((response) {
        return [response.body, response.statusCode];
      }).timeout(Duration(seconds: timeout), onTimeout: () {
        throw Exception();
      });
    } catch (ex) {
      return "failed";
    } finally {}
  }

  Future<dynamic> uploadFile(String filePath, Map<String, dynamic> form) async {
    try {
      var dio = di.Dio();
      dio.options.baseUrl = _mainBaseUrl;
      dio.options.connectTimeout = const Duration(seconds: 35000);
      dio.options.receiveTimeout = const Duration(seconds: 35000);
      dio.options.headers = await _getHeader();

      dio.interceptors
          .add(di.InterceptorsWrapper(onError: (di.DioError e, handler) {
        throw Exception(e);
      }));
      return dio.post("/image/match",
          data: di.FormData.fromMap({
            ...form,
            'image': await di.MultipartFile.fromFile(filePath),
          }),
          options: di.Options(
              method: "POST",
              validateStatus: (_) => true,
              responseType: di.ResponseType.plain),
          onSendProgress: (int sent, int total) {
        int a = (sent * 100) ~/ total;
      }).then((response) {
        if (response.statusCode == 200) {
          return convert.jsonDecode(response.data.toString());
        }
        return "failed";
      });
    } catch (ex) {
      return "failed";
    }
  }

  ///private method to return header   [_getHeader]
  Future<Map<String, String>> _getHeader() async {
    var value = <String, String>{
      'content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer ${BVNPlugin.getBearer()}',
    };
    return value;
  }
}
