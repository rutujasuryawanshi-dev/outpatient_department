import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outpatient_department/Model/clinic/select_staff_response.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/constants/utils.dart';
import 'package:outpatient_department/screens/home/home.dart';
import 'package:outpatient_department/screens/home/home_today_visit.dart';
import 'package:outpatient_department/widgets/snackbar.dart';

import '../../Controller/clinic_controller.dart';
import '../../Controller/profile_controller.dart';
import '../../Model/clinic/select_clinic_response.dart';
import '../../Model/profile/profile_response.dart';
import '../../constants/Constant.dart';
import '../../networking/api_endpoints.dart';
import '../../widgets/drawer.dart';
import '../../widgets/navbar.dart';

class SelectStaffAttachedToClinicScreen extends StatefulWidget {
  @override
  State<SelectStaffAttachedToClinicScreen> createState() =>
      _SelectStaffAttachedToClinicScreenState();
}

class _SelectStaffAttachedToClinicScreenState
    extends State<SelectStaffAttachedToClinicScreen> {
  num? _selectedStaff; // Holds the selected clinic
  final box = GetStorage();
  SelectClinicResponse? selectClinicResponse;
  List<SAttachedClinics> _sAttachedClinics = [];
  SelectStaffResponse? staffResponse;

  void _navigateToHome() {
    if (_selectedStaff == null) {
      Utils.showToastMessage('select your staff');
    } else {
      _getClinicToken();
    }
  }

  Future<void> _getClinicToken() async {
    if (await Utils.isConnected()) {
      bool _isLoading = true;
      Utils.onLoading(context);

      ClinicController clinicController = ClinicController();
      try {

        var clinicResponse = box.read(Constant.clinicTokenResponse);
        if(clinicResponse!=null&&clinicResponse!=''){
          selectClinicResponse = SelectClinicResponse.fromJson(json.decode(clinicResponse));
        }

        Map<String, dynamic> data = {
          "clinic_id": _selectedStaff ?? 0
        };

        final response = await clinicController.selectClinic(data, selectClinicResponse?.sData?.sAuthToken ?? '');

        if (response != null) {
          SelectClinicResponse selectClinicResponse =
          SelectClinicResponse.fromJson(response.data);

          if (selectClinicResponse.sCode == 200) {
            Navigator.pop(context);
            _isLoading = false;
            String clinicResponse = jsonEncode(response.data);
            box.write(Constant.clinicTokenResponse, clinicResponse);
            box.write(Constant.selectedClinic, _selectedStaff);
            showSnackBar(context, 1, 'welcome');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {}
        } else {
          print(response);
        }
      } catch (e) {
        print(e);
      } finally {
        if (_isLoading) {
          Navigator.pop(context);
        }
        setState(() {});
      }
    } else {
      Utils.showToastMessage(Constant.internetConMsg);
    }
  }

  @override
  void initState() {
    var clinicResponse = box.read(Constant.clinicTokenResponse);

    if (clinicResponse != null && clinicResponse != '') {
      selectClinicResponse = SelectClinicResponse.fromJson(json.decode(clinicResponse));
      _selectedStaff = box.read(Constant.selectedClinic);
      _getStaff();
    }
  }

  Future<void> _getStaff() async {
    if (await Utils.isConnected()) {
      bool _isLoading = true;

      Utils.onLoading(context);

      ClinicController controller = ClinicController();
      try {
        final response = await controller
            .selectStaff(selectClinicResponse?.sData?.sAuthToken);

        if (response != null) {
          staffResponse = SelectStaffResponse.fromJson(response.data);

          if (staffResponse?.sCode == 200) {
            Navigator.pop(context);

            _isLoading = false;

            setState(() {
              _sAttachedClinics = staffResponse!.sData!.sAttachedClinics!;
            });
          } else {
            Utils.showToastMessage('${staffResponse?.sMessage}');
          }
        } else {
          Utils.showToastMessage('Something went wrong!');
          print(response);
        }
      } catch (e) {
        Utils.showToastMessage('Something went wrong!');
        print(e);
      } finally {
        if (_isLoading) {
          Navigator.pop(context);
        }
      }
    } else {
      Utils.showToastMessage(Constant.internetConMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(1);
        return true;
      },
      child: Scaffold(
       /* appBar: Navbar(
          title: Constant.staff,
          transparent: true,
        ),
        backgroundColor: ArgonColors.primary,
        drawer: ArgonDrawer(currentPage: Constant.staff),*/
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 100.sp),
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
                          'Hello Dr. ${Constant.doctorname}, Please select your clinic',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _sAttachedClinics.length,
                            itemBuilder: (context, index) {
                              final staffName = _sAttachedClinics[index];

                              String mobile = (staffName.iClinicMobile == null || staffName.iClinicMobile!.isEmpty)
                                  ? "N/A"
                                  : staffName.iClinicMobile!;
                              String address = (staffName.iClinicAddress == null || staffName.iClinicAddress!.isEmpty)
                                  ? "N/A"
                                  : staffName.iClinicAddress!;
                              String email = (staffName.iClinicEmail == null || staffName.iClinicEmail!.isEmpty)
                                  ? "N/A"
                                  : staffName.iClinicEmail!;

                              String logo =
                              (staffName.iClinicLogo == null || staffName.iClinicLogo!.isEmpty)
                                  ?
                              "assets/img/staff.jpg"
                                  : staffName.iClinicLogo!
                              ;


                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8.0,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: /*Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        staffName.iClinicName!,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Radio<num>(
                                        value:int.parse(staffName.iClinicID!) ,
                                        groupValue: _selectedStaff,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedStaff = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),*/
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage: AssetImage("assets/img/staff.jpg",),
                                        backgroundColor: Colors.grey[200],
                                      ),

                                      SizedBox(width: 10.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              staffName.iClinicName!,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Mobile : ${mobile}",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Email : ${email}",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Address : ${address}",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Radio<num>(
                                        value: int.parse(staffName.iClinicID!),
                                        groupValue: _selectedStaff,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedStaff = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 40.sp,
                          width: 100.sp,
                          child: ElevatedButton(
                            onPressed: () {
                              _navigateToHome();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ArgonColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              padding:
                              EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
                            ),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 50.sp),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
