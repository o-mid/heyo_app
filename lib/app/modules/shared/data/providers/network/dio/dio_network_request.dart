import 'package:dio/dio.dart';
import 'package:heyo/app/modules/shared/data/providers/network/netowrk_request_provider.dart';
import 'package:heyo/app/modules/shared/data/providers/network/network_credentials.dart';
import 'package:heyo/app/modules/shared/utils/extensions/dio.extension.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioNetworkRequest extends NetworkRequest {
  final dio = Dio(BaseOptions(baseUrl: BASE_URL))
    ..interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );

  @override
  Future<Response> get({required String path, Map<String, dynamic>? queries}) {
    return dio.get(path, queryParameters: queries);
  }

  @override
  Future<Response> post(
      {required String path,
      Map<String, dynamic>? queries,
      Map<String, dynamic>? data}) {
    return dio.post(path, queryParameters: queries, data: data);
  }

  @override
  Future<Response> put({required String path, Map<String, dynamic>? queries}) {
    return dio.put(path, queryParameters: queries);
  }

  @override
  Future<Response> delete(
      {required String path, Map<String, dynamic>? queries}) {
    return dio.delete(path, queryParameters: queries);
  }
}
