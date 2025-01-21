import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/constants/utils.dart';
import 'package:outpatient_department/widgets/snackbar.dart';

import '../../Controller/clinic_controller.dart';
import '../../Model/Login/VerifyOTPResponse.dart';
import '../../Model/clinic/select_clinic_response.dart';
import '../../constants/Constant.dart';
import '../../widgets/drawer.dart';
import '../../widgets/navbar.dart';
import '../home/home.dart';

class ClinicListScreen extends StatefulWidget {
  VerifyOtpResponse? verifyOtpResponse;
  ClinicListScreen({super.key, required this.verifyOtpResponse});

  @override
  State<ClinicListScreen> createState() => _ClinicListScreenState();
}

class _ClinicListScreenState extends State<ClinicListScreen> {
  num? _selectedClinic; // Holds the selected clinic
  final box = GetStorage();
  List<AClinics> _clinics = [];
  void _navigateToHome() {
    if(_selectedClinic==null){
      Utils.showToastMessage('select your clinic');
    }
    else {
      _getClinicToken();
    }


  }

  Future<void> _getClinicToken() async {
    if (await Utils.isConnected()) {
      bool _isLoading = true;
      Utils.onLoading(context);
      VerifyOtpResponse? verifyOtpResponse;
      ClinicController clinicController = ClinicController();
      try {
        var loginresponse = box.read(Constant.loginResponse);
        verifyOtpResponse =
            VerifyOtpResponse.fromJson(json.decode(loginresponse));

        Map<String, dynamic> data = {
          "clinic_id": _selectedClinic ?? 0
        };

        final response = await clinicController.selectClinic(
            data, verifyOtpResponse?.sData?.aAuthToken ?? '');

        if (response != null) {
          SelectClinicResponse selectClinicResponse =
          SelectClinicResponse.fromJson(response.data);

          if (selectClinicResponse.sCode == 200) {
            Navigator.pop(context);
            _isLoading = false;
            String clinicResponse = jsonEncode(response.data);
            box.write(Constant.clinicTokenResponse, clinicResponse);
            box.write(Constant.selectedClinic, _selectedClinic);
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

  var doctorname='';


  @override
  void initState() {
    _clinics = widget.verifyOtpResponse?.sData?.aClinics??[];
    doctorname = widget.verifyOtpResponse?.sData?.iStaffDetails?.iStaffName??'';
    setState(() {
      _clinics;
      doctorname;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(1);
        return true;
      },
      child: Scaffold(
        /*  appBar: Navbar(
          title: Constant.clinic,
          transparent: true,
        ),
        backgroundColor: ArgonColors.primary,
        drawer: ArgonDrawer(currentPage: Constant.clinic),*/
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
                child: Column(
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
                                  'Hello Dr. ${doctorname}, Please select your clinic',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _clinics.length,
                                    itemBuilder: (context, index) {
                                      final clinicName = _clinics[index];
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                clinicName.clinicName!,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Radio<num>(
                                                value: int.parse(clinicName.clinicId!),
                                                groupValue: _selectedClinic,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedClinic = value;
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
                                      padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
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
              ),],)
      ),
    );
  }
}
