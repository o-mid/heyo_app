import 'package:dio/dio.dart';

extension VerifyResponse on Response {
  bool isSuccess() {
    if (statusCode == null) return false;
    return statusCode! >= 200 && statusCode! <= 299;
  }
}
