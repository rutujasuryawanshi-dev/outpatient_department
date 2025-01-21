
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:outpatient_department/Model/Appointment/GetAppointments.dart';
import 'package:outpatient_department/constants/Constant.dart';
import 'package:outpatient_department/screens/home/home.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Model/Login/VerifyOTPResponse.dart';
import '../screens/appointment/consultation_manual.dart';
import '../screens/appointment/consultation_photo.dart';
import '../screens/appointment/consultation_voice.dart';
import '../screens/clinic/clinic_list.dart';
import '../screens/home/home_today_visit.dart';
import '../widgets/snackbar.dart';

class Utils {

  static showToastMessage(String message,
      {Toast toastLength = Toast.LENGTH_SHORT}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        fontSize: 16.0
    );
  }

  static Future<bool> isConnected() async {
    try {
      List<InternetAddress> result = await InternetAddress.lookup('google.com')
      /*.timeout(Duration(seconds: 5))*/;

      //
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      //
      else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }


  static void onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                new Text("Loading"),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<String> selectDate(BuildContext context) async {
    var date = '';
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,

    );

    if (pickedDate != null) {
      date =  DateFormat('dd/MM/yyyy').format(pickedDate);
    }
    return date;
  }

  static int calculateAge(String dateString) {
    // Define the date format (dd/MM/yyyy)
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    // Parse the dateString to DateTime
    DateTime birthDate = dateFormat.parse(dateString);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference in years
    int age = currentDate.year - birthDate.year;

    // Adjust age if the current date hasn't passed the birthday yet this year
    if (currentDate.month < birthDate.month || (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  // Regular expression for email validation
  static bool isValidEmail(String input) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(input);
  }

  // Regular expression for mobile phone validation (basic example for 10 digits)
  static bool isValidPhone(String input) {
    String pattern = r'^[0-9]{10}$'; // You can adjust this pattern for different formats
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(input);
  }

  static void navigateToHome(BuildContext context) {
    final box = GetStorage();
    VerifyOtpResponse? verifyOtpResponse;
    var loginresponse = box.read(Constant.loginResponse);
    var  selectedClinic = box.read(Constant.selectedClinic);
    if(selectedClinic==null||selectedClinic==''){
      if(loginresponse!=null&&loginresponse!=''){
        verifyOtpResponse = VerifyOtpResponse.fromJson(json.decode(loginresponse));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClinicListScreen(verifyOtpResponse: verifyOtpResponse,)),
        );


      }
    }
    else {
      showSnackBar(context, 1, 'welcome');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }


  }

  static void navigateToConsultation(BuildContext context, Appointments appointment) {
    final box = GetStorage();
    String selectedOption = box.read('selectedOption') ?? '';
    if (selectedOption == "Use AI") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceConsultationScreen(appointment: appointment),
        ),
      );
    } else if (selectedOption == "Write Clinical Notes") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManualConsultationScreen(appointment: appointment),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConsultationPhotoScreen(appointment: appointment),
        ),
      );
      box.write('selectedOption', "Take Photo");
    }
  }

  static dialNumber(String phoneNumber,) async {
    final url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } catch (e) {
        Utils.showToastMessage('Error: Unable to initiate call');
      }
    } else {
      Utils.showToastMessage('Unable to call $phoneNumber. No suitable app found.');
    }
  }


}