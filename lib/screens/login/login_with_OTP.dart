import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:outpatient_department/Model/Login/LoginResponse.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/screens/login/setup_pin.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Controller/login_controller.dart';
import '../../Model/Login/ResendOTPResponse.dart';
import '../../Model/Login/VerifyOTPResponse.dart';
import '../../constants/Constant.dart';
import '../../constants/utils.dart';
import '../../widgets/snackbar.dart';

class LoginWithOTPPage extends StatefulWidget {
  const LoginWithOTPPage({super.key});

  @override
  State<LoginWithOTPPage> createState() => _LoginWithOTPPageState();
}

class _LoginWithOTPPageState extends State<LoginWithOTPPage> {

  final List<TextEditingController> pinControllers = List.generate(4, (_) => TextEditingController());

  final TextEditingController mobileController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  bool isPinSet=false, _isVisibleBiometric = false;
  bool rememberme = false;
  String errorMessage = '', _enterPin ='';



  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    isPinSet = (box.read(Constant.isPinSet) ?? false);
    _isVisibleBiometric = (box.read(Constant.isBiometric) ?? false);

    setState(() {
      rememberme = isPinSet;
    });
    _checkBiometrics();
  }



  Future<void> _userLogin() async {

    var otp_identifier = 0;
    if (Utils.isValidEmail(mobileController.text)) {
      otp_identifier = 1;
      print("This is a valid email");
    } else if (Utils.isValidPhone(mobileController.text)) {
      otp_identifier = 2;
      print("This is a valid mobile number");
    }

    if (await Utils.isConnected()) {
      bool _isLoading = true;
      Utils.onLoading(context);
      String emailOrMobile = mobileController.text;

      Map<String, dynamic> data =
      {
        "otp_identifier" : otp_identifier, //1 for Email , 2 for Mobile
        "input_identifier" : emailOrMobile//"bhagyashri.jadhav@holofx.io" // Email ID or Mobile number
      };

      LoginUserController loginUserController = LoginUserController();
      try {

        final response = await loginUserController.getLogin(data);

        if (response != null) {

          LoginResponse loginUser = LoginResponse.fromJson(response.data);

          if (loginUser.sCode == 200) {

            box.write(Constant.userName, emailOrMobile);

            Utils.showToastMessage('${loginUser.sMessage}');
            Navigator.pop(context);
            _isLoading = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyOTPPage(),
              ),
            );
          }
          else {
            Utils.showToastMessage('${loginUser.sMessage}');
          }
        } else {

          Utils.showToastMessage('Something went wrong!');
          print(response);
        }
      } catch (e) {
        Utils.showToastMessage('Something went wrong!');
        print(e);

      } finally {
        if(_isLoading){
          Navigator.pop(context);
        }
        setState(() {
          errorMessage='';
        });

      }
    }

    else {
      Utils.showToastMessage(Constant.internetConMsg);
    }

  }



  void _checkPin() {

    String pin=(box.read(Constant.PIN)?? '');
    /*String enteredPin =
    pinControllers.map((controller) => controller.text).join();*/

    setState(() {
      if (_enterPin == '') {
        errorMessage = 'Please enter PIN';
      } else if (_enterPin == pin) {
        errorMessage = '';
        _navigateToHome();
      } else {
        errorMessage = 'Invalid PIN';
      }
    });
  }


  void _CheckEmpty() {

    String emailOrMobile=mobileController.text;
    if (emailOrMobile != '') {
      /* setState(() {
          errorMessage = '';

        });*/


      if (!Utils.isValidEmail(emailOrMobile) && !Utils.isValidPhone(emailOrMobile)) {
        errorMessage =  'Please enter a valid email or phone number.';
        setState(() {
          errorMessage ;
        });
      }
      else {
        setState(() {
          errorMessage ;
        });
        _userLogin();
      }


    } else {
      setState(() {
        errorMessage = 'Please enter your Email or Mobile No.';

      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            Center(
              child: SingleChildScrollView(
                padding:  EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/medixcel_logo.png', // Logo added here
                      height: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Consult Freely. Practice Anywhere.',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 60),

                    if(isPinSet)
                      Container(
                        width: 360,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Enter your 4 digit PIN',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                              (index) => Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: _buildPinBox(pinControllers[index]),
                          ),
                        ),
                      ),*/

                            if (errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: _checkPin,
                              child: Text(
                                'Verify PIN',
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                                backgroundColor: ArgonColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            //
                            // Text(
                            //   'Forgot PIN?',
                            //   style: TextStyle(
                            //       fontSize: 16,
                            //       color: Colors.grey[600],
                            //       fontWeight: FontWeight.bold
                            //   ),
                            // ),
                            SizedBox(height: 10),
                            if (_isVisibleBiometric/*_availableBiometrics != null && _availableBiometrics!.isNotEmpty && isPinSet*/)
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 8.0,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: _authenticateWithBiometrics,
                                          child:  Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                  color: Colors.white,
                                                  FontAwesomeIcons
                                                      .fingerprint,
                                                  size: 15),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('Login With Biometric', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 17, /*fontFamily: 'main'*/))],),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(ArgonColors.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                    if(!isPinSet)
                      Text(
                        'Sign In with OTP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 20),
                    if(!isPinSet)
                      TextField(
                        controller: mobileController,
                        style:  TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Enter your Email or Mobile No.',
                          hintStyle:  TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          contentPadding:  EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    /*if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),*/

                    SizedBox(height: 20),
                    if(!isPinSet)

                      ElevatedButton(
                        onPressed: _CheckEmpty,
                        /*
                    onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyOTPPage(),
                      ),
                    );
                  },

         */
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ArgonColors.primary,
                          padding:  EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 40.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child:  Text(
                          'Send OTP',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget _buildPinBox(TextEditingController controller) {
    return SizedBox(
      height: 50,
      width: 40,
      child:

      TextField(
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
          /* if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }*/
        },

      ),
    );
  }


  void _navigateToHome() {
    Utils.navigateToHome(context);
    /* showSnackBar(context, 1, 'welcome');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );*/
  }


  Future<void> _checkBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      print('availableBiometrics $availableBiometrics');
    } on PlatformException catch (e) {
      _handleError(e);
    }
    if (mounted) {
      setState(() {
        _availableBiometrics = availableBiometrics;
      });
    }
  }

  // Authenticate using biometrics (either fingerprint or face)
  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    String localizedReason;

    final auth = LocalAuthentication();

    try {

      /*final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      print("Available biometrics: $availableBiometrics");

      if ((availableBiometrics.contains(BiometricType.strong) && availableBiometrics.contains(BiometricType.weak)) || availableBiometrics.contains(BiometricType.fingerprint)){
        localizedReason = 'Please authenticate using your fingerprint.';
      } else if (availableBiometrics.contains(BiometricType.strong)) {
        localizedReason = 'Please authenticate using your fingerprint.';
      } else if((availableBiometrics.contains(BiometricType.weak)) || availableBiometrics.contains(BiometricType.face)) {
        localizedReason = 'Please authenticate using your face.';
      } else {
        localizedReason = 'Please authenticate using your biometric credentials.';
      }*/

      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating...';
      });

      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate using your fingerprint or face.',
        //localizedReason: localizedReason,//'Please authenticate using your fingerprint or face.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
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

  // Handle any errors that occur during authentication
  void _handleError(PlatformException e) {
    print('Error: $e');
    setState(() {
      _isAuthenticating = false;
      _authorized = 'Error: ${e.message}';
    });
  }

}
class VerifyOTPPage extends StatefulWidget {
  const VerifyOTPPage({super.key});

  @override
  State<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {

  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  String errorMsg = '';
  String  enteredOtp = '';
  final box = GetStorage();

  void _CheckEmpty() {

    String otp =enteredOtp;

    if (otp == '') {
      errorMsg = 'Please enter OTP';
    }
    else  if (otp != '') {
      errorMsg = '';
      _verifyOTP();

    }
  }

  Future<void> _resendOTP() async {

    if (await Utils.isConnected()) {
      String emailOrMobile =(box.read(Constant.userName) ?? '');
      var otp_identifier = 0;
      if (Utils.isValidEmail(emailOrMobile)) {
        otp_identifier = 1;
        print("This is a valid email");
      } else if (Utils.isValidPhone(emailOrMobile)) {
        otp_identifier = 2;
        print("This is a valid mobile number");
      }

      Utils.onLoading(context);



      Map<String, dynamic> data =
      {
        "otp_identifier" : otp_identifier, //1 for Email , 2 for Mobile
        "input_identifier" : emailOrMobile//"bhagyashri.jadhav@holofx.io" // Email ID or Mobile number
      };

      LoginUserController loginUserController = LoginUserController();
      try {

        final response = await loginUserController.resendOTP(data);

        if (response != null) {

          ResendOtpResponse loginUser = ResendOtpResponse.fromJson(response.data);
          if (loginUser.sCode == 200) {

            Utils.showToastMessage('${loginUser.sMessage}');

          }
          else {
            Utils.showToastMessage('${loginUser.sMessage}');
          }
        } else {

          Utils.showToastMessage('Something went wrong!');
          print(response);
        }
      } catch (e) {

        Utils.showToastMessage('Something went wrong!');
        print(e);

      } finally {
        Navigator.pop(context);
      }
    }

    else {
      Utils.showToastMessage(Constant.internetConMsg);
    }

  }



  Future<void> _verifyOTP() async {

    String username = (box.read(Constant.userName) ?? '');

    if (await Utils.isConnected()) {
      String emailOrMobile =(box.read(Constant.userName) ?? '');
      var otp_identifier = 0;
      if (Utils.isValidEmail(emailOrMobile)) {
        otp_identifier = 1;
        print("This is a valid email");
      } else if (Utils.isValidPhone(emailOrMobile)) {
        otp_identifier = 2;
        print("This is a valid mobile number");
      }
      bool _isLoading = true;
      Utils.onLoading(context);
      Map<String, dynamic> data =
      {
        "otp_identifier" : otp_identifier, //1 for Email , 2 for Mobile
        "input_identifier" : username,//"sukrut.hindlekar@plus91.in",
        "login_otp" : int.parse(enteredOtp)
      };

      LoginUserController loginUserController = LoginUserController();
      try {

        final response = await loginUserController.verifyOTP(data);

        if (response != null) {

          VerifyOtpResponse verifyOtpResponse = VerifyOtpResponse.fromJson(response.data);
          if (verifyOtpResponse.sCode == 200) {

            String loginResponse=jsonEncode(response.data);

            box.write(Constant.loginResponse, loginResponse);

            Utils.showToastMessage('${verifyOtpResponse.sMessage}');
            Navigator.pop(context);
            _isLoading = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SetupPinPage(),
              ),
            );

          }
          else {
            Utils.showToastMessage('${verifyOtpResponse.sMessage}');
          }
        } else {

          Utils.showToastMessage('Something went wrong!');
          print(response);
        }
      } catch (e) {
        Utils.showToastMessage('Something went wrong!');
        print(e);

      } finally {
        if(_isLoading){
          Navigator.pop(context);
        }
        setState(() {
          errorMsg='';
        });

      }
    }

    else {
      Utils.showToastMessage(Constant.internetConMsg);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          ), Center(
            child: SingleChildScrollView(
              padding:  EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/medixcel_logo.png', // Logo added here
                    height: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Consult Freely. Practice Anywhere.',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 60),
                  Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 300,
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        enteredOtp = value;
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
                  if (errorMsg.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorMsg,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  SizedBox(height: 20),


                  ElevatedButton(
                    onPressed: _CheckEmpty,
                    /*
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetupPinPage(),
                      ),
                    );

                  },

                   */

                    style: ElevatedButton.styleFrom(
                      backgroundColor: ArgonColors.primary,
                      padding:  EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 40.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child:  Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(

                    onTap: () {
                      //Navigator.pop(context);
                      _resendOTP();
                    },
                    child:  Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),],
      ),
    );
  }


  Widget _buildPinBox(BuildContext context, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0), // Add space between the boxes
      child: SizedBox(
        height: 50,
        width: 40,
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
              FocusScope.of(context).nextFocus(); // Move to the next field
            } else {
              FocusScope.of(context).previousFocus(); // Move to the previous field
            }
          },
        ),
      ),
    );
  }



}
