import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:outpatient_department/Controller/AppointmentController.dart';
import 'package:outpatient_department/Controller/clinic_controller.dart';
import 'package:outpatient_department/Model/Appointment/GetAppointments.dart';
import 'package:outpatient_department/Model/Appointment/UploadAttachment.dart';
import 'package:outpatient_department/Model/clinic/select_clinic_response.dart';
import 'package:outpatient_department/screens/appointment/appointment_screen.dart';
import 'package:outpatient_department/screens/appointment/consultation_screen.dart';
import 'package:outpatient_department/screens/clinic/clinic_list.dart';
import 'package:outpatient_department/screens/patient/add_patient_screen.dart';
import 'package:outpatient_department/screens/patient/patientList_screen.dart';
import 'package:outpatient_department/widgets/drawer.dart';
import '../../Model/Appointment/CancelAppointment.dart';
import '../../Model/Login/VerifyOTPResponse.dart';
import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../constants/utils.dart';
import '../account_screen.dart';
import '../appointment/appoinment_details_screen.dart';
import '../chat_bot/chat_bot_screen.dart';
import '../notification/notifications.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;

import '../patient/patient_history_screen.dart';

List<Appointments> sampleAppointments = [
  Appointments(
    scheduleId: 1,
    appointmentId: 101,
    date: "2025-01-18",
    time: "10:00 AM",
    name: "Arjun Patel",
    gender: "Male",
    ageString: "30",
    ageType: "Years",
    age: 30,
    mobile: "9876543210",
    serviceType: "General Checkup",
    service: "Consultation",
    status: 1,
    doctorAlias: "Dr. Sharma",
    billId: 201,
    teleconsultationTypeId: 301,
    pendingAmount: 50,
    isServiceCompleted: 0,
    consultationId: 401,
  ),
  Appointments(
    scheduleId: 2,
    appointmentId: 102,
    date: "2025-01-19",
    time: "02:00 PM",
    name: "Priya Gupta",
    gender: "Female",
    ageString: "25",
    ageType: "Years",
    age: 25,
    mobile: "9123456789",
    serviceType: "Dental Checkup",
    service: "Consultation",
    status: 2,
    doctorAlias: "Dr. Kapoor",
    billId: 202,
    teleconsultationTypeId: 302,
    pendingAmount: 0,
    isServiceCompleted: 1,
    consultationId: 402,
  ),
  Appointments(
    scheduleId: 3,
    appointmentId: 103,
    date: "2025-01-20",
    time: "11:00 AM",
    name: "Suresh Reddy",
    gender: "Male",
    ageString: "45",
    ageType: "Years",
    age: 45,
    mobile: "9898989898",
    serviceType: "Heart Checkup",
    service: "Consultation",
    status: 1,
    doctorAlias: "Dr. Rao",
    billId: 203,
    teleconsultationTypeId: 303,
    pendingAmount: 100,
    isServiceCompleted: 0,
    consultationId: 403,
  ),
  Appointments(
    scheduleId: 4,
    appointmentId: 104,
    date: "2025-01-20",
    time: "11:00 AM",
    name: "Rohit Chavan",
    gender: "Male",
    ageString: "30",
    ageType: "Years",
    age: 30,
    mobile: "9702713057",
    serviceType: "Heart Checkup",
    service: "Consultation",
    status: 1,
    doctorAlias: "Dr. Rao",
    billId: 203,
    teleconsultationTypeId: 303,
    pendingAmount: 100,
    isServiceCompleted: 0,
    consultationId: 403,
  ),
];
/*
class BackgroundDesign extends StatefulWidget {
  final Widget child;
  TextEditingController _searchController = TextEditingController();

  BackgroundDesign({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(Constant.searchFlag)
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
                                hintText: 'Search Patient by Name, mobile, ABHA',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PatientlistScreen(),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: ArgonColors.primary,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
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
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: child,
          ),
        ),
      ],
    );
  }


}*/

class HomeTodayVisitScreen extends StatefulWidget {
  const HomeTodayVisitScreen({super.key});

  @override
  State<HomeTodayVisitScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeTodayVisitScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAnimated = false;
  List<String> filterOptions = ['Teleconsult', 'Completed', 'Paid', 'Unpaid'];
  // File? _selectedImage;
  List<File> _selectedImages = [];
  bool isAppointmentListNotEmpty = false;
  TextEditingController _searchController = TextEditingController();
  List<Appointments>? appointmentList = [];
  List<Appointments>? filteredList = [];

  late Future<Response?>? sampleDataFuture;

  final box = GetStorage();

  List<String> selectedFilters = [];

  TextEditingController paymentController = TextEditingController();
  String selectedPaymentMode = 'Cash'; // Default value
  double totalAmount = 0.00;
  num pendingAmount = 0.00;

  final List<String> paymentModes = ['Cash', 'Card', 'UPI'];
  Appointments? selected;
  final TextEditingController menuController = TextEditingController();

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
                        return SizedBox(
                          //height: 50,
                          child: CheckboxListTile(
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
                              });
                            },
                            activeColor: ArgonColors
                                .primary, // Color for the checkbox when selected
                            checkColor: ArgonColors
                                .white, // Color for the checkmark (inside the box)
                          ),
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
                              selectedFilters = [];
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
                            style: TextStyle(
                                color: ArgonColors.primary, fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
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
                            style: TextStyle(
                                color: ArgonColors.white, fontSize: 15),
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

  Future<void> _getAppointments() async {
    if (await Utils.isConnected()) {
      bool _isLoading = true;
      //Utils.onLoading(context);

      Map<String, dynamic> data = {
        "staff_id": "",
        "from_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "to_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };

      Appointmentcontroller appointmentcontroller = Appointmentcontroller();
      try {
        var clinicResponse = box.read(Constant.clinicTokenResponse);
        SelectClinicResponse selectClinicResponse =
        SelectClinicResponse.fromJson(json.decode(clinicResponse));
        String token = selectClinicResponse.sData!.sAuthToken!;

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
              filteredList = appointmentList;
            });

            if (appointmentList!.length != 0) {
              setState(() {
                isAppointmentListNotEmpty = true;
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
                      child: Text(
                        'Collect',
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

  Future<List<Appointments>> filterAppointments() async {
    if (selectedFilters.isEmpty) {
      return List.from(appointmentList ?? []);
    } else {
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

      List<Appointments> filteredAppointments =
          appointmentList?.where((appointment) {
            return filters.every((filter) => filter(appointment));
          }).toList() ??
              [];

      return filteredAppointments;
    }
  }

  void applyFilters() async {
    setState(() {
      appointmentList = filteredList;
    });

    List<Appointments> filteredAppointments = await filterAppointments();

    setState(() {
      appointmentList = filteredAppointments;
    });
  }

  Future<void> _uploadAndSaveAppointmentData(
      BuildContext context, StateSetter setState, num appointmentId) async {
    if (await Utils.isConnected()) {
      bool _isLoading = true;

      Utils.onLoading(context);
      String img64 = '';
      List<Map<String, dynamic>> attachments = [];

      for (var image in _selectedImages) {
        String fileName = path.basename(image.path);

        final bytes = io.File(image.path).readAsBytesSync();
        img64 = base64Encode(bytes);

        Map<String, dynamic> attachmentData = {
          "name": "Attachment report for consultation",
          "filename": fileName,
          "base64": img64,
          "date": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
          "description": "Demo Description"
        };

        attachments.add(attachmentData);
      }

      Map<String, dynamic> data = {
        "appointment_id": appointmentId,
        "attachments": attachments,
      };

      Appointmentcontroller appointmentcontroller = Appointmentcontroller();
      try {
        var clinicResponse = box.read(Constant.clinicTokenResponse);

        SelectClinicResponse selectClinicResponse =
        SelectClinicResponse.fromJson(json.decode(clinicResponse));
        String token = selectClinicResponse.sData!.sAuthToken!;

        final response = await appointmentcontroller
            .uploadAndSaveAppointmentData(data, token);

        if (response != null) {
          UploadAttachment attachment =
          UploadAttachment.fromJson(response.data);
          print('upload Appointment ${attachment}');

          if (attachment.sCode == 200) {
            setState(() {
              _selectedImages.clear();
            });
            Navigator.pop(context);
          }
          Utils.showToastMessage('${attachment.sMessage}');
        } else {
          Utils.showToastMessage('Something went wrong!');
          print(response);
        }
      } catch (e) {
        Utils.showToastMessage('Something went wrong!');
        print(e);
      } finally {
        //if(_isLoading){
        Navigator.pop(context);
        //  }
      }
    } else {
      Utils.showToastMessage(Constant.internetConMsg);
    }
  }

  Future<void> _cancelAppointments(num appointmentId, String reason) async {
    if (await Utils.isConnected()) {
      bool _isLoading = true;
      Utils.onLoading(context);

      Map<String, dynamic> data = {
        "appointment_id": appointmentId,
        "cancellation_reason": reason
      };

      Appointmentcontroller appointmentcontroller = Appointmentcontroller();
      try {
        var clinicResponse = box.read(Constant.clinicTokenResponse);
        SelectClinicResponse selectClinicResponse =
        SelectClinicResponse.fromJson(json.decode(clinicResponse));
        String token = selectClinicResponse.sData!.sAuthToken!;

        final response =
        await appointmentcontroller.cancelAppointment(data, token);

        if (response != null) {
          CancelAppointment appointment =
          CancelAppointment.fromJson(response.data);
          print('Cancel Appointment $appointment');

          Utils.showToastMessage('${appointment.sMessage}');
          if (appointment.sCode == 200) {
            Navigator.pop(context);
            _getAppointments();
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
        Navigator.pop(context);
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
                                    child:
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: DropdownMenu<Appointments>(
                                        controller: _searchController,
                                        width: 340,
                                        textStyle: TextStyle(color: Colors.black, fontSize: 12),
                                        hintText: selectedAppointment == null
                                            ? "Search Patient by Name, mobile, ABHA"
                                            : "Search Patient by Name, mobile, ABHA",
                                        selectedTrailingIcon: GestureDetector(
                                          onTap: () {
                                            if(_searchController.text.isNotEmpty){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PatientlistScreen(),
                                                ),
                                              );
                                            }
                                            else {
                                              Utils.showToastMessage('Enter Patient Name, mobile, ABHA');
                                            }
                                          },
                                          child: Icon(
                                            Icons.search_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        trailingIcon: GestureDetector(
                                          onTap: () {
                                            if(_searchController.text.isNotEmpty){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PatientlistScreen(),
                                                ),
                                              );
                                            }
                                            else {
                                              Utils.showToastMessage('Enter Patient Name, mobile, ABHA');
                                            }
                                          },
                                          child: Icon(
                                            Icons.search_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        requestFocusOnTap: true,
                                        enableFilter: true,
                                        inputDecorationTheme: InputDecorationTheme(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: Colors.black, fontSize: 12),
                                        ),
                                        menuStyle: MenuStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        ),
                                        onSelected: (Appointments? appointment) {
                                          setState(() {
                                            selectedAppointment = appointment;
                                            _searchController.text = appointment?.name ?? '';
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PatientHistoryScreen(appointment: appointment)),
                                          );
                                        },
                                        dropdownMenuEntries: filteredAppointments
                                            .map<DropdownMenuEntry<Appointments>>(
                                                (Appointments appointment) {
                                              return DropdownMenuEntry<Appointments>(
                                                value: appointment,
                                                label: appointment.name ?? "No name available",                                               );
                                            }).toList(),
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
                              child:
                              Image.asset('assets/img/nodata.jpg')),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "You have no visit today",
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
                      itemCount: appointmentList!.length,
                      itemBuilder: (context, index) {
                        final appointment = appointmentList![index];
                        Color appointmentColor;
                        Border appointmentBorder;
                        BoxShadow boxShadow;
                        bool showTick = false;

                        DateTime currentTime = DateTime.now();
                        DateTime todayAtCurrentTime = DateTime(
                          currentTime.year,
                          currentTime.month,
                          currentTime.day,
                          currentTime.hour,
                          currentTime.minute,
                        );

                        DateTime next15Minutes =
                        todayAtCurrentTime.add(Duration(minutes: 15));

                        String appointmentTimeString = appointment.time!;
                        DateTime appointmentTime = DateFormat('HH:mm')
                            .parse(appointmentTimeString);

                        DateTime appointmentDate =
                        DateFormat('yyyy-MM-dd')
                            .parse(appointment.date!);

                        appointmentTime = DateTime(
                          appointmentDate.year,
                          appointmentDate.month,
                          appointmentDate.day,
                          appointmentTime.hour,
                          appointmentTime.minute,
                        );

                        if (appointment.isServiceCompleted == 1) {
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
                        } else if ((appointmentTime.isAtSameMomentAs(
                            todayAtCurrentTime) ||
                            appointmentTime
                                .isAfter(todayAtCurrentTime)) &&
                            (appointmentTime
                                .isAtSameMomentAs(next15Minutes) ||
                                appointmentTime
                                    .isBefore(next15Minutes))) {
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
                        } else {
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

                        return GestureDetector(
                          onLongPress: () {
                            _selectedImages.clear();
                            _showAppointmentOptions(context, appointment);
                          },
                          onTap: () {
                            Utils.navigateToConsultation(
                                context, appointment);
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
                                        if (appointment.pendingAmount !=
                                            '' &&
                                            appointment.pendingAmount !=
                                                0)
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                pendingAmount = appointment!
                                                    .pendingAmount ??
                                                    0.0;
                                                paymentController.text =
                                                    pendingAmount
                                                        .toString();
                                              });

                                              showAcceptPaymentDialog(
                                                  context);
                                            },
                                            child: Text(
                                              'Rs ${appointment.pendingAmount!} Pending',
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
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                '/${appointment.age!} ${appointment.ageType == 'Years' ? '' : appointment.ageType}',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(width: 5.0),
                                              if (appointment
                                                  .teleconsultationTypeId ==
                                                  1)
                                                Icon(
                                                  Icons.videocam,
                                                  color:
                                                  Color(0xFF333333),
                                                  size: 12.sp,
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0.sp),
                                          Text(
                                            appointment.service! +
                                                '(' +
                                                appointment.serviceType! +
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
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        isAppointmentListNotEmpty
            ? Positioned(
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
        Positioned(
          bottom: 30,
          right: 30,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatBotScreen()),
              );
            },
            backgroundColor: ArgonColors.primary,
            child: Image.asset(
              'assets/img/robot.png',
              height: 30,
              width: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  VerifyOtpResponse? verifyOtpResponse;
  List<Appointments> filteredAppointments = [];
  Appointments? selectedAppointment;
  @override
  void initState() {
    super.initState();
    Constant.searchFlag = false;
    _getAppointments();
    filteredAppointments = sampleAppointments;
    _searchController.addListener(_filterAppointments);
  }
  void _filterAppointments() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredAppointments = sampleAppointments
          .where((appointment) =>
      appointment.name!.toLowerCase().contains(query) ||
          appointment.mobile!.contains(query) ||
          appointment.serviceType!.toLowerCase().contains(query))
          .toList();
    });
  }
  @override
  void dispose() {
    _searchController.removeListener(_filterAppointments);
    _searchController.dispose();
    super.dispose();
  }
  void _showAppointmentOptions(BuildContext context, Appointments appointment) {
    num appointmentId = appointment.appointmentId ?? 0;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter updateState) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Appointment Actions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.upload_file, color: Colors.blue),
                      title: Text("Rx upload and save"),
                      onTap: () {
                        _showUploadOptions(context, updateState);
                      },
                    ),
                    // Show selected images
                    if (_selectedImages.isNotEmpty)
                      Column(
                        children: [
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: _selectedImages.map((image) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 45.sp,
                                width: 45.sp,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                  image: DecorationImage(
                                    image: FileImage(image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 15,
                                      top: -16,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          updateState(() {
                                            _selectedImages.remove(
                                                image); // Remove the image from the list
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _uploadAndSaveAppointmentData(
                                  context, updateState, appointmentId);
                            },
                            child: const Text(
                              "Upload",
                              style: TextStyle(
                                  color: ArgonColors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ArgonColors.primary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.cancel, color: Colors.red),
                          title: Text("Cancel"),
                          onTap: () {
                            showCancelAppointmentDialog(context, appointmentId);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.schedule, color: Colors.blue),
                          title: Text("Reschedule"),
                          onTap: () {
                            // _showRescheduleDialog(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentScreen(
                                  appointments:
                                  appointment, // Pass your list of appointments here
                                ),
                              ),
                            );
                          },
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

  void showCancelAppointmentDialog(BuildContext context, num appointmentId) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Cancel Appointment",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 12),
                  border: OutlineInputBorder(),
                  hintText: "Enter your reason here",
                ),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel",
                  style: TextStyle(color: ArgonColors.primary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ArgonColors.primary,
              ),
              onPressed: () {
                String reason = reasonController.text;
                if (reason.isNotEmpty) {
                  _cancelAppointments(appointmentId, reason);

                  Navigator.pop(context);
                } else {
                  Utils.showToastMessage('Please provide a reason.');
                }
              },
              child:
              const Text("OK", style: TextStyle(color: ArgonColors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showUploadOptions(BuildContext context, StateSetter setState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Upload Rx",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.blue),
                  title: Text("Use Camera"),
                  onTap: () async {
                    Navigator.pop(context);
                    final picker = ImagePicker();
                    final pickedImage =
                    await picker.pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      setState(() {
                        _selectedImages.add(File(pickedImage.path));
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.green),
                  title: Text("Choose from Gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    final picker = ImagePicker();
                    final pickedImages = await picker.pickMultiImage();
                    if (pickedImages != null) {
                      setState(() {
                        _selectedImages.addAll(pickedImages
                            .map((pickedImage) => File(pickedImage.path))
                            .toList());
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRescheduleDialog(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      selectedDate = date;
    }

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (time != null) {
      selectedTime = time;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rescheduled Appointment'),
          content: Text(
              'Your appointment has been rescheduled to: ${selectedDate.toLocal().toString().split(' ')[0]} at ${selectedTime.format(context)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
