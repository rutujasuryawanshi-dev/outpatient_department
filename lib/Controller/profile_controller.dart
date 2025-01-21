import 'dart:async';
import 'package:dio/dio.dart';

import '../networking/dio_client.dart';


class ProfileController extends DioClient {

  Future<Response?> getProfileDetails(token) async {
    return await requestGET(
      path: '/getProfileDetails',
      token: token,
    );
  }
}