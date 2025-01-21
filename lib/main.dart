import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outpatient_department/screens/home/home_today_visit.dart';
import 'package:outpatient_department/screens/login/faceID_fingerprint.dart';
import 'package:outpatient_department/screens/login/login.dart';
import 'package:outpatient_department/screens/login/login_screen.dart';
import 'package:outpatient_department/screens/splash_screen.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'OpenSans'),
       /* theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),*/
        home: SplashScreen()/*FaceidFingerprintScreen()*/,
      ),
    );
  }
}

