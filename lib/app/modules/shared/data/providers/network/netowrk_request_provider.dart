import 'package:dio/dio.dart';

abstract class NetworkRequest {
  Future<Response> put({required String path, Map<String, dynamic>? queries});

  Future<Response> post({
    required String path,
    Map<String, dynamic>? queries,
    Map<String, dynamic> data,
  });

  Future<Response> get({required String path, Map<String, dynamic>? queries});

  Future<Response> delete({required String path, Map<String, dynamic>? queries});
}
