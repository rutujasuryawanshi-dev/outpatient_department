import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/constants/utils.dart';
import 'package:outpatient_department/screens/login/add_faceId.dart';
import 'package:outpatient_department/widgets/snackbar.dart';

import '../../Model/Login/VerifyOTPResponse.dart';
import '../../constants/Constant.dart';
import '../clinic/clinic_list.dart';

class FaceidFingerprintScreen extends StatefulWidget {
  const FaceidFingerprintScreen({super.key});

  @override
  State<FaceidFingerprintScreen> createState() =>
      _FaceidFingerprintScreenState();
}

class _FaceidFingerprintScreenState extends State<FaceidFingerprintScreen> {
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  final LocalAuthentication auth = LocalAuthentication();
  final box = GetStorage();
  /*void _navigateToHome() {
    VerifyOtpResponse? verifyOtpResponse;
    var loginresponse = box.read(Constant.loginResponse);
    var  selectedClinic = box.read(Constant.selectedClinic);
    if(selectedClinic==null&&selectedClinic==''){
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


  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:Stack(
          children: [
            Opacity(
              opacity: 0.2,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/connect_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),Center(
              child: Column(
                children: [
                  SizedBox(height: 200.sp),
                  Image.asset(
                    'assets/img/medixcel_logo.png',
                    height: 70.sp,
                  ),
                  SizedBox(height: 10.sp),
                  Text(
                    'Consult Freely. Practice Anywhere',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 60.sp),
                  Text(
                    'Do you want to setup face ID for alternate login?',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.sp,
                        child: ElevatedButton(
                          onPressed: () {
                            box.write(Constant.isBiometric, false);
                            Utils.navigateToHome(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: ArgonColors.primary),
                            ),
                            padding: EdgeInsets.all(10.0),
                          ),
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: ArgonColors.primary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: 100.sp,
                        child: ElevatedButton(
                          onPressed: _authenticateWithBiometrics,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ArgonColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                          ),
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),],)
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating...';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate using your fingerprint or face.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true, // Biometric only (fingerprint or face)
        ),
      );
    } on PlatformException catch (e) {
      _handleError(e);
      return;
    }
    if (mounted) {
      setState(() {
        _isAuthenticating = false;
        _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      });

      if (authenticated) {
        box.write(Constant.isBiometric, true);
        Utils.navigateToHome(context);
      }
    }
  }

  void _handleError(PlatformException e) {
    print('Error: $e');
    setState(() {
      _isAuthenticating = false;
      _authorized = 'Error: ${e.message}';
    });
  }
}
