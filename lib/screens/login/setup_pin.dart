import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:outpatient_department/screens/login/faceID_fingerprint.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../constants/utils.dart';

class SetupPinPage extends StatefulWidget {

  @override
  _SetupPinPageState createState() => _SetupPinPageState();

}

class _SetupPinPageState extends State<SetupPinPage> {
  String _enterPin = '', _reEntredPin = '';
  final LocalAuthentication auth = LocalAuthentication();
  final box = GetStorage();
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  bool isPinSet=false;
  bool rememberme = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'SET-UP NEW PIN',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
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
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPinInputSection(
                          label: "Enter new PIN",
                        ),
                        SizedBox(height: 16.0.h),
                        _buildReEnteredPinInputSection(
                          label: "Re-enter new PIN",
                        ),
                        SizedBox(height: 16.0.h),
                        Text(
                          'PIN is a 4-digit PIN that you have to set for mandatory two-factor authentication',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                        ),
                        /* SizedBox(height: 10.0.h),
                    Text('• Digits Should not be in series e.g.1234/4321', style: TextStyle(fontSize: 10.sp)),
                    SizedBox(height: 8.0.h),
                    Text('• All digits should not be same', style: TextStyle(fontSize: 10.sp)),
                    SizedBox(height: 8.0.h),
                    Text('• PIN & re-entered PIN should match', style: TextStyle(fontSize: 10.sp)),
                    SizedBox(height: 10.0.h),
                    Text(
                      '*Last 5 PINs Cannot be reused',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp),
                    ),*/
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          final box = GetStorage();
                          box.write(Constant.isPinSet, false);
                          box.write(Constant.PIN, '');
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: ArgonColors.primary, fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50.0.w, vertical: 10.0.h),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: ArgonColors.primary),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _validateAndSubmit,
                        child: Text(
                          'Set PIN',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50.0.w, vertical: 10.0.h),
                          backgroundColor: ArgonColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),]
      ),
    );
  }


  void show() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 250.sp,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_triangle_fill,
                  color:  ArgonColors.primary,
                  size: 55.sp,
                ),
                SizedBox(height: 16.sp),
                Text(
                  'Do you want to login using your fingerprint or face ID?',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.sp),
                Text(
                  'All the fingerprints, face IDs stored on this device can be used to access the App. Please set up your biometric login from your device settings before proceeding.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.sp,
                      child: ElevatedButton(
                        onPressed: _authenticateWithBiometrics,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ArgonColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all( 14.0),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
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
                        onPressed:(){
                          _navigateToHome();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: ArgonColors.primary),
                          ),
                          padding: EdgeInsets.all( 14.0),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: ArgonColors.primary,
                            fontSize: 12.sp,
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
          ),
        );
      },
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
        box.write(Constant.isPinSet, rememberme);
        _navigateToHome();
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
  void _navigateToHome() {
    Utils.navigateToHome(context);
    /* showSnackBar(context, 1, 'welcome');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );*/
  }

  Widget _buildPinInputSection({
    required String label,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0.h),
          Container(
            width: 200,
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              onChanged: (value) {
                _enterPin = value;
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 40.h,
                fieldWidth: 40.w,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                activeColor: Colors.blue,
                selectedColor: Colors.blue,
                inactiveColor: Colors.grey,
              ),
              keyboardType: TextInputType.number,
              cursorColor: Colors.blue,
            ),
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              4,
                  (index) => Padding(
                padding: EdgeInsets.only(right: 8.0.w),
                child: _buildPinBox(controllers[index]),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildReEnteredPinInputSection({
    required String label,
    /*required List<TextEditingController> controllers,*/
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0.h),
          Container(
            width: 200,
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              onChanged: (value) {
                _reEntredPin = value;
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 40.h,
                fieldWidth: 40.w,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                activeColor: Colors.blue,
                selectedColor: Colors.blue,
                inactiveColor: Colors.grey,
              ),
              keyboardType: TextInputType.number,
              cursorColor: Colors.blue,
            ),
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              4,
                  (index) => Padding(
                padding: EdgeInsets.only(right: 8.0.w),
                child: _buildPinBox(controllers[index]),
              ),
            ),
          ),*/
        ],
      ),
    );
  }


  Widget _buildPinBox(TextEditingController controller) {
    return SizedBox(
      height: 50.h,
      width: 40.w,
      child: TextField(
        controller: controller,
        obscureText: true,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
        },

      ),
    );
  }

  void _validateAndSubmit() {
    final newPin = _enterPin;
    final reEnterPin = _reEntredPin;

    if (newPin.length != 4 || reEnterPin.length != 4) {
      _showPopup(false, 'PIN must be 4 digits long');
      return;
    }

    else if (newPin != reEnterPin) {
      _showPopup(false, 'PIN and Re-entered PIN do not match');
      return;
    }
/*
    else if (RegExp(r'^(.)\1*$').hasMatch(newPin)) {
      _showPopup(false, 'All digits should not be the same');
      return;
    }

    else  if (hasSeriesOrReverse(newPin, 4)) {
      _showPopup(false, 'Digits should not be in a series or reverse series');
      return;
    }*/
    else {
      _showPopup(true, 'PIN successfully set');

    }


  }

  bool hasSeriesOrReverse(String pin, int seriesLength) {
    for (int i = 0; i <= pin.length - seriesLength; i++) {
      String subPin = pin.substring(i, i + seriesLength);
      if (isSeriesOrReverse(subPin)) {
        return true;
      }
    }
    return false;
  }

  bool isSeriesOrReverse(String pin) {
    if (pin.length < 2) return false; // A series requires at least 2 digits

    bool isAscending = true;
    bool isDescending = true;

    for (int i = 0; i < pin.length - 1; i++) {
      int current = int.parse(pin[i]);
      int next = int.parse(pin[i + 1]);

      if (next - current != 1) isAscending = false; // Not ascending
      if (current - next != 1) isDescending = false; // Not descending

      // If neither ascending nor descending, no need to check further
      if (!isAscending && !isDescending) return false;
    }

    return isAscending || isDescending;
  }


  void _showPopup(bool isSuccess, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: 48.sp,
              ),
              SizedBox(height: 16.0.h),
              Text(
                isSuccess ? 'Success' : 'Error',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              SizedBox(height: 8.0.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {

                if (isSuccess) {
                  final box = GetStorage();

                  box.write(Constant.isPinSet, true);
                  box.write(Constant.PIN,_enterPin);

                  //showSnackBar(context, 1, 'welcome');
                  // show();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => FaceidFingerprintScreen()),
                        (Route<dynamic> route) => false,
                  );
                }
                else{
                  Navigator.of(context).pop();
                  final box = GetStorage();

                  box.write(Constant.isPinSet, false);
                  box.write(Constant.PIN, '');

                }

              },
              child: Text('OK', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        );
      },
    );
  }
}
