import 'dart:async';
import 'package:dio/dio.dart';

import '../networking/dio_client.dart';


class Appointmentcontroller extends DioClient {

  Future<Response?> getAppointments(jsonData,token) async =>
      await requestPOST(
          path: "/getAppointments",
          body: jsonData,
          token:token
      );

  Future<Response?> getAppointmentData(jsonData,token) async =>
      await requestPOST(
          path: "/getAppointmentData",
          body: jsonData,
          token:token

      );
  Future<Response?> cancelAppointment(jsonData,token) async =>
      await requestPOST(
          path: "/cancelAppointment",
          body: jsonData,
          token:token

      );
  Future<Response?> uploadAndSaveAppointmentData(jsonData,token) async =>
      await requestPOST(
          path: "/uploadAttachments",
          body: jsonData,
          token:token

      );

}