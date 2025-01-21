import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:outpatient_department/screens/home/home.dart';

import '../../constants/Theme.dart';
import '../../widgets/input.dart';
import '../../widgets/navbar.dart';
import '../home/home_today_visit.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _checkboxValue = false;

  final double height = window.physicalSize.height;
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  List<BiometricType>? _availableBiometrics;


  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // appBar: Navbar(transparent: true, title: "Login"),
       // extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/register-bg.png"),
                      fit: BoxFit.cover)),
            ),
            SafeArea(
              child: //Container(
               /* child:*/ ListView(children: [

                  Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Image.asset(
                      'assets/img/medixcel_logo.png',
                      //width: 100.sp,
                      height: 70.sp,
                    ),
                  ),
                  Center(
                    child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 24.0, right: 24.0, bottom: 0),
                    child: Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30, left: 0.0, right: 0.0, bottom: 40),
                          child: Column(
                            children: [
                              Container(
                                // height: MediaQuery.of(context).size.height * 0.63,
                                  color: Color.fromRGBO(244, 245, 247, 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                    
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Input(
                                                    placeholder: "Email",
                                                    prefixIcon: Icon(Icons.email)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Input(
                                                    placeholder: "Password",
                                                    prefixIcon: Icon(Icons.lock)),
                                              ),
                                    
                                              Padding(
                                                padding: const EdgeInsets.only(top: 25),
                                                child: Center(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      foregroundColor: ArgonColors.primary,//change background color of button
                                                      backgroundColor: ArgonColors.white,//change text color of button
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),),
                                    
                                                    onPressed: () {
                                                      // Respond to button press
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                                                      );
                                                    },
                                    
                                                    child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0,
                                                            top: 12,
                                                            bottom: 12),
                                                        child: Text("LOGIN",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                fontSize: 16.0))),
                                                  ),
                                                ),
                                              )
                                    
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30.0, bottom: 30.0),
                                            child: Center(
                                              child: Text(
                                                  "Or Login with the other way",
                                                  style: TextStyle(
                                                      color: ArgonColors.text,
                                                      fontWeight: FontWeight.w200,
                                                      fontSize: 16)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              Container(
                                // height: MediaQuery.of(context).size.height * 0.15,
                                  decoration: BoxDecoration(
                                      color: ArgonColors.white,
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: ArgonColors.muted))),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      /*  Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text("Sign up with",
                                                    style: TextStyle(
                                                        color: ArgonColors.text,
                                                        fontSize: 16.0)),
                                              )),*/
                                      if (_availableBiometrics != null && _availableBiometrics!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 0.0),
                                        child: Container(
                                          width: 250,
                                          height: 36,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: ArgonColors.secondary,//change background color of button
                                                backgroundColor: ArgonColors.primary,//change text color of button
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                ),),

                                              onPressed: _authenticateWithBiometrics,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 0,
                                                      top: 0,
                                                      left: 10,
                                                      right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Icon(
                                                          FontAwesomeIcons
                                                              .fingerprint,
                                                          size: 13),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("Login with biometric",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              fontSize: 13))
                                                    ],
                                                  ))),
                                        ),
                                      ),
                                      // Divider()
                                    ],
                                  )),
                            ],
                          ),
                        )),
                                    ),
                  ),],),
             // ),
            )
          ],
        ));
  }

  // Check if biometrics are available (face or fingerprint)
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

  // Navigate to the Home screen after successful authentication
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
