import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:outpatient_department/Controller/clinic_controller.dart';
import 'package:outpatient_department/Model/clinic/select_clinic_response.dart';
import 'package:outpatient_department/screens/appointment/appointment_screen.dart';
import 'package:outpatient_department/screens/appointment/consultation_screen.dart';
import 'package:outpatient_department/screens/clinic/clinic_list.dart';
import 'package:outpatient_department/screens/patient/add_patient_screen.dart';
import 'package:outpatient_department/screens/patient/patientList_screen.dart';
import 'package:outpatient_department/widgets/drawer.dart';

import '../../Controller/AppointmentController.dart';
import '../../Model/Appointment/GetAppointments.dart';
import '../../Model/Login/VerifyOTPResponse.dart';
import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../constants/utils.dart';

class HomeYesterdayVisitScreen extends StatefulWidget {
  const HomeYesterdayVisitScreen({super.key});

  @override
  State<HomeYesterdayVisitScreen> createState() =>
      _HomeYesterdayVisitScreenState();
}

class _HomeYesterdayVisitScreenState extends State<HomeYesterdayVisitScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAnimated = false;
  TextEditingController _searchController = TextEditingController();
  List<String> filterOptions = ['Teleconsult', 'Completed', 'Paid', 'Unpaid'];
  bool isYesterdayAppointmentListNotEmpty=false;
  List<Appointments>? appointmentList = [];

  late Future<Response?>? sampleDataFuture;

  List<String> selectedFilters = [];

  List<Appointments>? filteredList = [];

  TextEditingController paymentController = TextEditingController();
  String selectedPaymentMode = 'Cash'; // Default value
  double totalAmount = 0.00;
  double netAmount = 0.00;
  num pendingAmount = 0.00;

  final List<String> paymentModes = ['Cash','Card','UPI'];


  Future<List<Appointments>> filterAppointments() async {

    if (selectedFilters.isEmpty) {

      return List.from(appointmentList ?? []);

    }
    else{

      final filters = <bool Function(Appointments)>[];

      if (selectedFilters.contains('Teleconsult')) {
        filters.add((appointment) => appointment.teleconsultationTypeId == 0);
      }
      if (selectedFilters.contains('Completed')) {
        filters.add((appointment) => appointment.isServiceCompleted == 1);
      }
      if (selectedFilters.contains('Paid')) {
        filters.add((appointment) => appointment.pendingAmount == 0);
      }
      if (selectedFilters.contains('Unpaid')) {
        filters.add((appointment) => appointment.pendingAmount != 0);
      }

      List<Appointments> filteredAppointments = appointmentList?.where((appointment) {
        return filters.every((filter) => filter(appointment));
      }).toList() ?? [];

      return filteredAppointments;
    }


  }

  void applyFilters() async {

    setState(() {
      appointmentList=filteredList;

    });

    List<Appointments> filteredAppointments = await filterAppointments();

    setState(() {
      appointmentList = filteredAppointments;
    });
  }

  void _showMultiSelectPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Section
                    Center(
                      child: Text(
                        "Select Filters",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Filter Options Section
                    Column(
                      children: filterOptions.map((option) {
                        final isSelected = selectedFilters.contains(option);
                        return CheckboxListTile(
                          title: Text(
                            option,
                            style: TextStyle(fontSize: 15),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            dialogSetState(() {
                              if (value == true &&
                                  !selectedFilters.contains(option)) {
                                selectedFilters.add(option);
                              } else if (value == false &&
                                  selectedFilters.contains(option)) {
                                selectedFilters.remove(option);
                              }
                            }
                            );
                          },
                          activeColor: ArgonColors.primary,  // Color for the checkbox when selected
                          checkColor: ArgonColors.white,          // Color for the checkmark (inside the box)
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              selectedFilters=[];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ArgonColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style:
                            TextStyle(color: ArgonColors.primary, fontSize: 15),
                          ),
                        ),
                        SizedBox(width: 10,),
                        ElevatedButton(
                          onPressed: () {
                            applyFilters();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ArgonColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Apply',
                            style:
                            TextStyle(color: ArgonColors.white, fontSize: 15),
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
      },
    );
  }

  void showAcceptPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ArgonColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Accept Payment',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ArgonColors.black,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payment Mode",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 150,
                            child: DropdownButtonFormField<String>(
                              value: selectedPaymentMode,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedPaymentMode = newValue!;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                              ),
                              items: paymentModes.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(fontSize: 10)),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 150,
                            child: TextFormField(
                              controller: paymentController,
                              style: TextStyle(fontSize: 10),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(fontSize: 10),
                                hintText: 'Enter Payment',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Pending Amount",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold)),
                          Text('Rs. ${pendingAmount.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Collect',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ArgonColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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


  final box = GetStorage();

  Future<void> _getYesterdayAppointments() async {
    if (await Utils.isConnected()) {
      bool _isLoading = true;
      //Utils.onLoading(context);

      Map<String, dynamic> data = {
        "staff_id": "",
        "from_date": DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(Duration(days: 1))),
        "to_date": DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(Duration(days: 2))),
      };

      Appointmentcontroller appointmentcontroller = Appointmentcontroller();
      try {
        var clinicResponse = box.read(Constant.clinicTokenResponse);
        SelectClinicResponse selectClinicResponse =
        SelectClinicResponse.fromJson(json.decode(clinicResponse));
        String token = selectClinicResponse.sData!.sAuthToken!;
        //String token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MzY0MTQ4OTIsImV4cCI6MTczNjY3NDA5MiwiaVN0YWZmSUQiOiIxMjM5MSIsImlDbGluaWNJRCI6MTA3fQ.PbjJ8EcUT5rmZ18gll_PxrrcT-O_B67AN5skQiz08jE";

        final response =
        await appointmentcontroller.getAppointments(data, token);

        if (response != null) {
          GetAppointments appointments =
          GetAppointments.fromJson(response.data);

          if (appointments.sCode == 200) {
            setState(() {
              appointmentList = [];
              filteredList = [];
              appointmentList = appointments!.sData!.appointments ?? [];
              filteredList=appointmentList;
            });

            if (appointmentList!.length != 0 ){
              setState(() {
                isYesterdayAppointmentListNotEmpty=true;

              });
            }

          } else {
            Utils.showToastMessage('${appointments.sMessage}');
          }
        } else {
          Utils.showToastMessage('Something went wrong!');
          print(response);
        }
      } catch (e) {
        Utils.showToastMessage('Something went wrong!');
        print(e);
      } finally {
        //if(_isLoading){
        //Navigator.pop(context);
        //  }
      }
    } else {
      Utils.showToastMessage(Constant.internetConMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          /* key: _scaffoldKey,
          drawer: ArgonDrawer(currentPage: Constant.home),
          appBar: AppBar(
            backgroundColor: ArgonColors.primary,
            automaticallyImplyLeading: false,
            elevation: 2.0,
            title: Row(
              children: [
                SizedBox(width: 8.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dr. Karan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "Lifewave Clinic",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Spacer(),
                Wrap(children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        Constant.searchFlag = !Constant.searchFlag;
                      });
                    },
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/img/add_user.png',
                      height: 19.sp,
                      width: 19.sp,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AppointmentScreen()));
                    },
                  ),
                ])
              ],
            ),
          ),

          */
          body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (Constant.searchFlag)
                  Container(
                    decoration: BoxDecoration(
                      color: ArgonColors.primary,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 9.0,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: TextField(
                                      controller: _searchController,
                                      style: TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText:
                                        'Search Patient by Name, mobile, ABHA',
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PatientlistScreen(),
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.search,
                                            color: ArgonColors.primary,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(30.0),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: ArgonColors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    Constant.searchFlag = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                //SizedBox(height: 10.sp),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      /*borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),*/
                    ),
                    child: (appointmentList == null || appointmentList!.isEmpty)
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 250,
                              //height: 100,
                              child: Image.asset('assets/img/nodata.jpg')),
                          SizedBox(height: 20,),
                          Text(
                            "You have no visit",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.all(6.0),
                      itemCount: appointmentList?.length!,
                      itemBuilder: (context, index) {
                        String? previousDate = '';

                        if (index > 0) {
                          final app = appointmentList![index - 1];
                          previousDate = app.date!;
                        }

                        final appointment = appointmentList![index];

                        String yesterdayDate = DateFormat('yyyy-MM-dd')
                            .format(DateTime.now()
                            .subtract(Duration(days: 1)));

                        String appointmentDate = appointment.date!;
                        String displayDate = appointmentDate;

                        if (appointmentDate == yesterdayDate) {
                          displayDate = 'Yesterday';
                          if (index != 0) {
                            previousDate = 'Yesterday';
                          }
                        }

                        Color appointmentColor;
                        Border appointmentBorder;
                        BoxShadow boxShadow;
                        bool showTick = false;
                        /*
                        if (index >= appointments.length - 3) {
                          appointmentColor = Colors.grey[200]!;
                          appointmentBorder = Border.all(
                            color: Colors.grey[100]!,
                            width: 1.5,
                          );
                          showTick = true;
                          boxShadow = BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8.0,
                            offset: Offset(0, 3),
                          );
                        } else if (index == 3) {
                          appointmentColor = Colors.transparent;
                          appointmentBorder = Border.all(
                            color: Colors.grey[500]!,
                            width: 1.5,
                          );
                          showTick = false;
                          boxShadow = BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8.0,
                            offset: Offset(0, 3),
                          );
                        }
                        else */
                        {
                          appointmentColor = Colors.transparent;
                          appointmentBorder = Border.all(
                            color: Colors.transparent,
                            width: 1.5,
                          );
                          showTick = false;
                          boxShadow = BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8.0,
                            offset: Offset(0, 3),
                          );
                        }

                        IconData? typeIcon;
                        Color typeIconColor = Color(0xFF333333);
                        if (appointment.teleconsultationTypeId == 1) {
                          typeIcon = Icons.videocam;
                        }

                        return Column(
                          children: [
                            if (displayDate != previousDate)
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 5.0),
                                    child: Text(
                                      displayDate,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            GestureDetector(
                              onTap: () {
                                Utils.navigateToConsultation(context, appointment);

                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 3.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: appointmentColor,
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: appointmentBorder,
                                  boxShadow: [boxShadow],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            if (appointment.pendingAmount != '' && appointment.pendingAmount != 0 )

                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    pendingAmount=appointment!.pendingAmount ?? 0.0;
                                                    paymentController.text=pendingAmount.toString();
                                                  });

                                                  showAcceptPaymentDialog(context);

                                                },
                                                child: Text(
                                                  'Rs ${appointment.pendingAmount} Pending',
                                                  style: TextStyle(
                                                    fontSize: 8.sp,
                                                    color: Color(0xFFF5A623),
                                                  ),
                                                ),
                                              ),
                                            SizedBox(height: 6.0.sp),
                                            Text(
                                              appointment.time!,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 12.0.sp),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(

                                                    child: Text(
                                                      appointment.name!,
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.0.sp),
                                                  Text(
                                                    appointment.gender!,
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color:
                                                      Colors.grey[600],
                                                    ),
                                                  ),
                                                  Text(
                                                    '/${appointment.age!} ${appointment.ageType == 'Years' ? '' : appointment.ageType}',
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color:
                                                      Colors.grey[600],
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.0),
                                                  if (typeIcon != null)
                                                    Icon(
                                                      typeIcon,
                                                      color: typeIconColor,
                                                      size: 12.sp,
                                                    ),
                                                ],
                                              ),
                                              SizedBox(height: 10.0.sp),
                                              Text(
                                                appointment.service! +
                                                    '(' +
                                                    appointment
                                                        .serviceType! +
                                                    ')',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        if (showTick)
                                          Icon(
                                            Icons.check,
                                            color: ArgonColors.green,
                                            size: 15.sp,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        isYesterdayAppointmentListNotEmpty ? Positioned(
          top: Constant.searchFlag ? 90 : 10,
          right: 5,
          child: IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              size: 30,
              color: selectedFilters.isEmpty
                  ? ArgonColors.primary
                  : ArgonColors.green,
            ),
            onPressed: _showMultiSelectPopup,
          ),
        )
            : SizedBox.shrink(),

      ],
    );
  }

  VerifyOtpResponse? verifyOtpResponse;
  @override
  void initState() {
    super.initState();
    Constant.searchFlag = false;
    _getYesterdayAppointments();
  }

}
