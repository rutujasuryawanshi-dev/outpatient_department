import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/screens/home/home.dart';
import 'package:outpatient_department/screens/home/home_today_visit.dart';
import 'package:outpatient_department/widgets/snackbar.dart';

import '../../constants/Constant.dart';
import '../../constants/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isPasswordVisible = false;
  bool rememberme = false;

  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  bool isAlreadyLogin=false;
  String name = '';

  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    isAlreadyLogin = (box.read(Constant.isAlreadyLogin) ?? false);
    name = (box.read(Constant.name)?? '');

    setState(() {
      name;
      rememberme = isAlreadyLogin;
    });
    _checkBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _FormKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  child: Column(
                    children: [
                      Image.asset('assets/img/medixcel_logo.png', width: 300, height: 200),

                      if(isAlreadyLogin)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Hey, $name!",textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.blue, fontSize: 25,
                              fontWeight: FontWeight.bold,
                              /*fontFamily: 'Trajan'*/)),
                      ),
                      /*if(isAlreadyLogin)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Please Sign in To Continue", style: TextStyle(fontSize: 16, *//*fontFamily: 'main',*//* fontWeight: FontWeight.normal, color: Colors.black87))),*/

                      if(!isAlreadyLogin)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Login",textAlign: TextAlign.left,
                            style: TextStyle(
                            color: Colors.black87, fontSize: 35,
                            fontWeight: FontWeight.bold,
                            /*fontFamily: 'Trajan'*/)),
                      ),
                      if(!isAlreadyLogin)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Please Sign in To Continue", style: TextStyle(fontSize: 16, /*fontFamily: 'main',*/ fontWeight: FontWeight.normal, color: Colors.black87))),

                      const SizedBox(height: 20),
                      if(!isAlreadyLogin)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              prefixIcon: Icon(CupertinoIcons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 22.0,vertical: 0),
                            ),
                            validator: (username) {
                              if (username == null || username.isEmpty) {
                                return 'Username is required';
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _passController,
                            obscureText: !_isPasswordVisible, // Toggle visibility based on the state
                            obscuringCharacter: '*',
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: Icon(CupertinoIcons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
                            ),
                            validator: (pass) {
                              if (pass == null || pass.isEmpty) {
                                return 'Enter a Valid Password';
                              }
                             /* if (pass.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }*/
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Reminder Me Next Time',
                                  style: TextStyle(fontSize: 17, color: Colors.black87, /*fontFamily: 'main'*/),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    value: rememberme,
                                    onChanged: (bool value) {
                                      setState(() {
                                        rememberme = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                           /* if (!rememberme)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Please check the Reminder Me option.',
                                  style: TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ),*/
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
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
                          onPressed: () {
                            if (_FormKey.currentState!.validate()) {
                           /*   ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Login Successful with Email: ${_emailController.text}',
                                  ),
                                ),
                              );*/


                              if(((isAlreadyLogin || _emailController.text=='rohit@holofx.io')&&_passController.text=='Test@1234') || ((isAlreadyLogin || _emailController.text=='alok@connect')&&_passController.text=='Test@32123'))
                              {
                                //Utils.showToastMessage('welcome');
                                box.write(Constant.isAlreadyLogin, true);
                                box.write(Constant.userName, _emailController.text);
                                box.write(Constant.password, _passController.text);
                                box.write(Constant.name, 'Rohit');
                                _navigateToHome();
                              }
                              else {
                                box.write(Constant.isAlreadyLogin, false);
                                box.write(Constant.userName, '');
                                box.write(Constant.password, '');
                                box.write(Constant.name, '');
                                Utils.showToastMessage('Invalid username or password');
                              }
                            }
                          },
                          child:  Text('Sign In', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 17, /*fontFamily: 'main'*/)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(ArgonColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account?", style: TextStyle(color: Colors.black87)),
                      TextButton(
                        onPressed: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );*/
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            /*fontFamily: 'main',*/
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),

              if (_availableBiometrics != null && _availableBiometrics!.isNotEmpty && isAlreadyLogin)
              Padding(
                padding: const EdgeInsets.only(top: 15),
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
      ),
    );
  }
  void _navigateToHome() {
    showSnackBar(context, 1, 'welcome');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
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
        box.write(Constant.isAlreadyLogin, rememberme);
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