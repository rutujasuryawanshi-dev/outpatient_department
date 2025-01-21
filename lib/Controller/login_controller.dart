import 'dart:async';
import 'package:dio/dio.dart';

import '../networking/dio_client.dart';


class LoginUserController extends DioClient {


  Future<Response?> getLogin(jsonData) async =>
        await requestPOST(
          path: "/login",
          body: jsonData,
          token: ''
      );


  Future<Response?> verifyOTP(jsonData) async =>
      await requestPOST(
          path: "/verifyOTP",
          body: jsonData,
          token: ''
      );

  Future<Response?> resendOTP(jsonData) async =>
      await requestPOST(
          path: "/resendOTP",
          body: jsonData,
          token: ''
      );


}