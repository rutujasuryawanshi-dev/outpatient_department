import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outpatient_department/Controller/profile_controller.dart';
import 'package:outpatient_department/Model/clinic/select_clinic_response.dart';
import 'package:outpatient_department/Model/profile/profile_response.dart';
import 'package:outpatient_department/screens/appointment/appointment_screen.dart';
import 'package:outpatient_department/widgets/navbar.dart';

import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../constants/utils.dart';
import '../../widgets/drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box = GetStorage();
  SelectClinicResponse? selectClinicResponse;
  ProfileResponse? profileResponse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          title: Constant.profile,
          transparent: true,
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: ArgonDrawer(currentPage: Constant.profile),
        body: Stack(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage("assets/img/profile-screen-bg.png"),
                      fit: BoxFit.fitWidth))),
          SafeArea(
            child: ListView(children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, top: 74.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: .0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 85.0, bottom: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Align(
                                          child: Text(
                                            profileResponse?.sData?.sUserProfileDetails?.iStaffName??Constant.nA,
                                            style: TextStyle(
                                              color: Color.fromRGBO(50, 50, 93, 1),
                                              fontSize: 28.0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Align(
                                          child: Text(
                                            profileResponse?.sData?.sUserProfileDetails?.iStaffType??Constant.nA,
                                            style: TextStyle(
                                              color: Color.fromRGBO(50, 50, 93, 1),
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          child: Text(
                                            "MCI Reg No:23232324",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 40.0,
                                          thickness: 1.5,
                                          indent: 32.0,
                                          endIndent: 32.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                                          child: Align(
                                            child: Text(
                                              "${(profileResponse?.sData?.sUserProfileDetails?.iDesignation ?? '').isNotEmpty && (profileResponse?.sData?.sUserProfileDetails?.iQualification ?? '').isNotEmpty
                                                  ? "${profileResponse?.sData?.sUserProfileDetails?.iDesignation}, ${profileResponse?.sData?.sUserProfileDetails?.iQualification}"
                                                  : (profileResponse?.sData?.sUserProfileDetails?.iDesignation ?? profileResponse?.sData?.sUserProfileDetails?.iQualification ?? '')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromRGBO(82, 95, 127, 1),
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(height: 25.0),
                                        // Align(
                                        //   child: Text(
                                        //     "JessicaJones@gmail.com",
                                        //     style: TextStyle(
                                        //       fontSize: 15,
                                        //     ),
                                        //   ),
                                        // ),
                                        // SizedBox(height: 10.0),
                                        // Align(
                                        //   child: Text(
                                        //     "+91 3424343424",
                                        //     style: TextStyle(
                                        //       fontSize: 15,
                                        //     ),
                                        //   ),
                                        // ),
                                        SizedBox(height: 20.0),
                                        Container(
                                          height: 50.0,
                                          child: FloatingActionButton.extended(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => AppointmentScreen(appointments: null)),
                                              );
                                            },
                                            label: Padding(
                                              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
                                              child: Text(
                                                'Book Appointment',
                                                style: TextStyle(color: Colors.white, fontSize: 13),
                                              ),
                                            ),
                                            backgroundColor: ArgonColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(100.0),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(height: 20.0),
                                        // Align(
                                        //   child: Text(
                                        //     "Consultation Fees",
                                        //     style: TextStyle(
                                        //       fontSize: 18.0,
                                        //       fontWeight: FontWeight.w600,
                                        //       color: Color.fromRGBO(50, 50, 93, 1),
                                        //     ),
                                        //   ),
                                        // ),
                                        // SizedBox(height: 10.0),
                                        // Align(
                                        //   child: Text(
                                        //     "Online Consultation: ₹500",
                                        //     style: TextStyle(
                                        //       fontSize: 15.0,
                                        //       color: Color.fromRGBO(82, 95, 127, 1),
                                        //     ),
                                        //   ),
                                        // ),
                                        // Align(
                                        //   child: Text(
                                        //     "Offline Consultation: ₹1000",
                                        //     style: TextStyle(
                                        //       fontSize: 15.0,
                                        //       color: Color.fromRGBO(82, 95, 127, 1),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],

                                    ),
                                  ),
                                ],
                              ),
                            )),

                      ),
                      FractionalTranslation(
                          translation: Offset(0.0, -0.5),
                          child: Align(
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/img/doctor.jpg"),
                              radius: 65.0,
                              // maxRadius: 200.0,
                            ),
                            alignment: FractionalOffset(0.5, 0.0),
                          ))
                    ]),
                  ],
                ),
              ),
            ]),
          )
        ]
        )

    );
  }


  @override
  void initState() {
    var clinicResponse = box.read(Constant.clinicTokenResponse);
    if(clinicResponse!=null&&clinicResponse!=''){
      selectClinicResponse = SelectClinicResponse.fromJson(json.decode(clinicResponse));
      _getProfile();
    }
  }

  Future<void> _getProfile() async {
    if (await Utils.isConnected()) {
      bool _isLoading = true;
      Utils.onLoading(context);


      ProfileController profileController = ProfileController();
      try {

        final response = await profileController.getProfileDetails(selectClinicResponse?.sData?.sAuthToken);
        if (response != null) {
          profileResponse = ProfileResponse.fromJson(response.data);
          if (profileResponse?.sCode == 200) {
            //Utils.showToastMessage('${profileResponse.sMessage}');
            Navigator.pop(context);
            _isLoading = false;
            setState(() {
              profileResponse;
            });
          }
          else {
            Utils.showToastMessage('${profileResponse?.sMessage}');
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
      }
    }

    else {
      Utils.showToastMessage(Constant.internetConMsg);
    }

  }
}

