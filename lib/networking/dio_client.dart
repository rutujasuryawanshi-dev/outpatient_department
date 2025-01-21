import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:developer';
import 'api_endpoints.dart';



class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30000),
      receiveTimeout: const Duration(seconds: 30000),
    ),
  );


 Future<Response?> requestPOST({required String path, dynamic body, required String token}) async {
    try {
      var response = await dio.post(path, data: body, options: Options(headers:{'Content-Type': 'application/json',
        "Authorization":"Bearer ${token}"},));

      if (kDebugMode) {
        log(jsonEncode(response.data), name: '$path - ${response.statusCode}');
      }
      return response;
    } on DioError catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection Timeout Exception");
      }
      print('dioError${ex.message}');
      throw Exception((ex.message));
    }
  }

  Future<Response?> requestGET({required String path, required String token}) async {
    try {
      var response = await dio.get(path , options: Options(headers:{"Authorization":"Bearer $token"},));

      return response;
    } on DioError catch (ex) {
      if (ex.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection Timeout Exception");
      }
      print('dioError${ex.message}');
      throw Exception((ex.message));
    }
  }


}
