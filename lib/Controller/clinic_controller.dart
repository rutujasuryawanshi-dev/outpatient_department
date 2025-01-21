import 'dart:async';
import 'package:dio/dio.dart';

import '../networking/dio_client.dart';


class ClinicController extends DioClient {

  Future<Response?> selectClinic(jsonData, token) async {
    return await requestPOST(
      path: '/selectClinic',
      body: jsonData,
      token: token,
    );
  }

  Future<Response?> getRefreshToken(token) async {
    return await requestGET(
      path: '/refreshToken',
      token: token,
    );
  }

  Future<Response?> selectStaff(token) async {
    return await requestGET(
      path: '/getStaffAttachedClinics',
      token: token,
    );
  }






}