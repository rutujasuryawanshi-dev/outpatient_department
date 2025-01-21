import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:outpatient_department/screens/about/help_support_screen.dart';
import 'package:outpatient_department/screens/account_screen.dart';
import 'package:outpatient_department/screens/appointment/appointment_screen.dart';
import 'package:outpatient_department/screens/login/login_with_OTP.dart';
import 'package:outpatient_department/screens/patient/patientList_screen.dart';
import 'package:outpatient_department/screens/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:outpatient_department/constants/Theme.dart';

import 'package:outpatient_department/widgets/drawer-tile.dart';

import '../Model/profile/profile_response.dart';
import '../constants/Constant.dart';
import '../screens/about/aboutus_screen.dart';
import '../screens/appointment/appoinment_list_screen.dart';
import '../screens/bill/billing_screen.dart';
import '../screens/home/home.dart';
import '../screens/login/login_screen.dart';
import '../screens/performance/performance_screen.dart';
import '../screens/profile/setting_screen.dart';

class ArgonDrawer extends StatelessWidget {
  final String? currentPage;

  ArgonDrawer({this.currentPage});

  _launchURL() async {
    const url = 'https://creative-tim.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ProfileResponse? profileData;
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var profileResponse = box.read(Constant.profileResponse);
    if(profileResponse!=null&&profileResponse!='') {
      profileData = ProfileResponse.fromJson(json.decode(profileResponse));
    }
    return Drawer(
        child: Container(
          color: ArgonColors.white,
          child: Column(children: [
            GestureDetector(
              onTap :(){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                      ),
                    ));
              },
              child: Container(
                padding: EdgeInsets.only(top: 70, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 100),
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundImage: AssetImage('assets/img/doctor.jpg'),
                    // ),
                    // SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${profileData?.sData?.sUserProfileDetails?.iStaffName?.startsWith('Dr.') == true
                              ? profileData?.sData?.sUserProfileDetails?.iStaffName
                              : 'Dr. ${profileData?.sData?.sUserProfileDetails?.iStaffName ?? ''}'}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4,),
                        Text(
                          "${profileData?.sData?.sUserProfileDetails?.iStaffNo??''}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 2,),
                        if((profileData?.sData?.sUserProfileDetails?.iDesignation ?? '').isNotEmpty && (profileData?.sData?.sUserProfileDetails?.iQualification ?? '').isNotEmpty)
                          Text(
                            "${(profileData?.sData?.sUserProfileDetails?.iDesignation ?? '').isNotEmpty && (profileData?.sData?.sUserProfileDetails?.iQualification ?? '').isNotEmpty
                                ? "${profileData?.sData?.sUserProfileDetails?.iDesignation}, ${profileData?.sData?.sUserProfileDetails?.iQualification}"
                                : (profileData?.sData?.sUserProfileDetails?.iDesignation ?? profileData?.sData?.sUserProfileDetails?.iQualification ?? '')}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                        SizedBox(height: 2,),
                        Text(
                          Constant.clinicName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 4, thickness: 0, color: ArgonColors.muted),
            SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: ListView(
                padding: EdgeInsets.only(left: 16, right: 16),
                children: [
                  DrawerTile(
                      icon: Icons.home,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                              ),
                            ));
                      },
                      iconColor: ArgonColors.primary,
                      title: Constant.home,
                      isSelected: currentPage == Constant.home ? true : false),
                  DrawerTile(
                      icon: Icons.account_circle,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientlistScreen(
                              ),
                            ));
                      },
                      iconColor: ArgonColors.info,
                      title: Constant.patient,
                      isSelected: currentPage == Constant.patient ? true : false),
                  DrawerTile(
                      icon: Icons.settings_input_component,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillingScreen(
                              ),
                            ));
                      },
                      iconColor: ArgonColors.error,
                      title: Constant.billing,
                      isSelected: currentPage == Constant.billing ? true : false),
                  DrawerTile(
                      icon: Icons.settings,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingScreen(
                              ),
                            ));
                      },
                      iconColor: ArgonColors.success,
                      title: Constant.settings,
                      isSelected: currentPage == Constant.settings ? true : false),

                  DrawerTile(
                      icon: Icons.pie_chart,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PerformanceScreen(
                              ),
                            ));
                      },
                      iconColor: ArgonColors.warning,
                      title: Constant.performance,
                      isSelected: currentPage == Constant.performance ? true : false),
                  /*DrawerTile(
                      icon: Icons.pie_chart,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                              ),
                            ));
                      },
                      iconColor: ArgonColors.warning,
                      title: Constant.profile,
                      isSelected: currentPage == Constant.profile ? true : false),*/

                  /*DrawerTile(
                      icon: Icons.apps,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppoinmentListScreen(
                              ),
                            ));
                      },
                      iconColor: ArgonColors.primary,
                      title: Constant.appointments,
                      isSelected: currentPage == Constant.appointments ? true : false),*/

                  DrawerTile(
                      icon: Icons.desk,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpSupportScreen(
                              ),
                            ));
                      },
                      iconColor: ArgonColors.muted,
                      title: Constant.help,
                      isSelected:
                      currentPage == Constant.help ? true : false),
                ],
              ),
            ),
            Divider(height: 4, thickness: 0, color: ArgonColors.muted),
            SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.only(left: 15, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap :(){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                ),
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 25, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/img/medixcel_logo.png',
                                height: 60,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Consult Freely.Practice Anywhere',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "V- 1.0",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 60),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutUs(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 50),
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider( thickness: 0, color: ArgonColors.muted),
                      // DrawerTile(
                      //     icon: Icons.info_outline,
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => AboutUs(
                      //             ),
                      //           ));
                      //     },                      iconColor: ArgonColors.muted,
                      //     title: "About Us",
                      //     isSelected:
                      //     currentPage == "Getting started" ? true : false),
                      //
                      // DrawerTile(
                      //     icon: Icons.desk,
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => HelpSupportScreen(
                      //             ),
                      //           ));
                      //     },                      iconColor: ArgonColors.muted,
                      //     title: "Help and Support",
                      //     isSelected:
                      //     currentPage == "Getting started" ? true : false),
                      Center(
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              Dialogs.materialDialog(
                                msg: 'Are you sure?',
                                title: "Logout",
                                color: Colors.white,
                                context: context,
                                actions: [
                                  IconsOutlineButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    shape: btnShape,
                                    text: 'Cancel',
                                    iconData: Icons.cancel_outlined,
                                    textStyle: TextStyle(color: Colors.grey),
                                    iconColor: Colors.grey,
                                  ),
                                  IconsButton(
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => LoginWithOTPPage()),
                                            (Route<dynamic> route) => false,
                                      );
                                    },
                                    text: 'Logout',
                                    iconData: Icons.logout,
                                    color: Colors.red,
                                    textStyle: TextStyle(color: Colors.white),
                                    iconColor: Colors.white,
                                  ),
                                ],
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Color(0xFFF5A623),
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 8.sp),
                                Icon(
                                  Icons.logout,
                                  color: Color(0xFFF5A623),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ]),
        ));
  }

}
