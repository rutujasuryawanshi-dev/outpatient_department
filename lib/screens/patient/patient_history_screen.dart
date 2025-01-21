import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outpatient_department/Model/Appointment/GetAppointments.dart';
import 'package:outpatient_department/constants/Constant.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/screens/patient/PatientHistoryDetails.dart';
import 'package:outpatient_department/widgets/app_bar.dart';
import 'package:outpatient_department/widgets/drawer.dart';

import '../../constants/utils.dart';
import '../../widgets/searchbar.dart';

class PatientHistoryScreen extends StatefulWidget {
  final Appointments? appointment;

  const PatientHistoryScreen({super.key,required this.appointment});

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isABDMEnabled = true;
  bool isSummaryExpanded = false;
  final List<Map<String, String>> visitHistory = [
    {"date": "1/1/2024", "details": "High BP (Pre-existing hypertension complicating pregnancy, childbirth and the puerperium, O10)"},
    {"date": "1/1/2024", "details": "Diarrhoea (Diarrhoea, unspecified R19.7)"},
    {"date": "1/9/2023", "details": "Prescription issued", "icon": "rx"},
    {"date": "4/8/2023", "details": "Prescription issued", "icon": "rx"},
    {"date": "7/1/2023", "details": "Viral flu"},
    {"date": "2/1/2023", "details": "EMR not available"},
  ];

  final box = GetStorage();

  TextEditingController _searchPatientController = TextEditingController();
  Appointments? selectedPatient;
  List<Appointments> filteredPatientData = [];
  bool searchFlag = false;
  @override
  void initState() {
    filteredPatientData = Constant.samplePatientData;
    _searchPatientController.addListener(_filterAppointments);

    super.initState();
  }


  void _filterAppointments() {
    String query = _searchPatientController.text.toLowerCase();
    setState(() {
      filteredPatientData = Constant.samplePatientData
          .where((appointment) =>
      appointment.name!.toLowerCase().contains(query) ||
          appointment.mobile!.contains(query) ||
          appointment.serviceType!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchPatientController.removeListener(_filterAppointments);
    _searchPatientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    return Scaffold(
      backgroundColor: ArgonColors.white,
      key: _scaffoldKey,
      drawer: ArgonDrawer(currentPage: ''),
      appBar: CustomAppBar(
        doctorName: Constant.doctorname,
        clinicName: Constant.clinicName,
        scaffoldKey: _scaffoldKey,
        isABDMEnabled: isABDMEnabled,
        onRefresh: (bool value){
          setState(() {
            searchFlag = !searchFlag;
          });
        },
      ),
      body: Stack(
        children: [
          // Main Content
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (searchFlag)
                    SearchAppointmentWidget(
                      searchController: _searchPatientController,
                      filteredAppointments: filteredPatientData,
                      selectedAppointment: selectedPatient,
                      onAppointmentSelected: (Appointments? appointment) {
                        setState(() {
                          selectedPatient = appointment;
                          _searchPatientController.text = appointment?.name ?? '';
                        });
                      },
                    ),
                  // Patient Details Section
                  Container(
                    color: Colors.white30,
                    padding: const EdgeInsets.only(
                        left: 12.0, top: 12.0, bottom: 4.0, right: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  appointment?.name ?? '',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5.0.sp),
                                Text(
                                  appointment?.gender ?? '',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '/${appointment?.age ?? '0'} ${appointment?.ageType == 'Years' ? '' : appointment?.ageType ?? ''}',
                                  style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                                ),
                                SizedBox(width: 5.0),
                                if (appointment?.teleconsultationTypeId == 1)
                                  Icon(
                                    Icons.videocam,
                                    color: Color(0xFF333333),
                                    size: 12.sp,
                                  ),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              appointment?.mobile ?? '',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        if (appointment?.mobile != null && appointment?.mobile!.isNotEmpty == true)
                          IconButton(
                            icon: Icon(Icons.phone, color: Colors.black),
                            onPressed: () {
                              Utils.dialNumber(appointment!.mobile!);
                            },
                          ),
                      ],
                    ),
                  ),
                  // Medical Summary Section
                  Container(
                    color: Colors.white70,
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Medical Summary",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: ArgonColors.primary,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isSummaryExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: ArgonColors.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  isSummaryExpanded = !isSummaryExpanded;
                                });
                              },
                            ),
                          ],
                        ),
                        if (isSummaryExpanded)
                          Text(
                            "Visited 15 days ago for hypertension and high cholesterol. Often complains of headaches and dizziness (6 visits this year). "
                                "Takes Amlodipine 5 mg and Atorvastatin 20 mg. Allergic to penicillin and peanuts. Has Type 2 Diabetes for 10 years.\n"
                                "Smokes 5 cigs/day, drinks alcohol occasionally. Family history of heart disease and diabetes. BP: 150/90, BMI: 28. "
                                "Needs diet changes and to quit smoking for better health.",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[800],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0), // Add padding
                    child: Align(
                      alignment: Alignment.centerLeft, // Aligns the text to the left
                      child: Text(
                        'Visit History',
                        style: TextStyle(
                          color: ArgonColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Appointments appointment = Appointments(
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
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientHistoryDetails(appointment: appointment)),
                      );
                    },
                    child:Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            "1/1/2024",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 20.sp),
                          Expanded(
                            child: Text(
                              "High BP (Pre-existing hypertension complicating pregnancy, childbirth and the puerperium, O10)",
                              style: TextStyle(fontSize: 14.0, color: Colors.grey[800]),
                            ),
                          ),
                          Icon(Icons.access_time, size: 20.0, color: Colors.amberAccent),

                        ],
                      ),
                    ),
                  ),


                  // Container 2
                  InkWell(
                    onTap: () {
                      Appointments appointment = Appointments(
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
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientHistoryDetails(appointment: appointment)),
                      );
                    },
                    child:
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            "1/1/2024",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 20.sp),
                          Expanded(
                            child: Text(
                              "Diarrhoea (Diarrhoea, unspecified R19.7)",
                              style: TextStyle(fontSize: 14.0, color: Colors.grey[800]),
                            ),
                          ),
                          Icon(Icons.access_time, size: 20.0, color: Colors.amberAccent),

                        ],
                      ),
                    ),
                  ),
                  // Container 3
                  // Container 3
                  InkWell(
                    onTap: () {
                      Appointments appointment = Appointments(
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
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientHistoryDetails(appointment: appointment)),
                      );
                    },
                    child:
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            "1/9/2023",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 20.0), // Space between the time icon and the date
                          Icon(Icons.file_copy_outlined, size: 20.0, color: Colors.grey[700]),

                          Spacer(), // Pushes the next icon to the right
                          Icon(Icons.access_time, size: 20.0, color: Colors.amberAccent),
                        ],
                      ),
                    ),
                  ),

                  // Container 4
                  InkWell(
                    onTap: () {
                      Appointments appointment = Appointments(
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
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientHistoryDetails(appointment: appointment)),
                      );
                    },
                    child:
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            "4/8/2023",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),                      SizedBox(width: 20.0), // Space between the time icon and the date
                          Icon(Icons.file_copy_outlined, size: 20.0, color: Colors.grey[700]),

                          Spacer(), // Pushes the next icon to the right
                          Icon(Icons.access_time, size: 20.0, color: Colors.amberAccent),
                        ],
                      ),
                    ),
                  ),

                  // Container 5
                  InkWell(
                    onTap: () {
                      Appointments appointment = Appointments(
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
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientHistoryDetails(appointment: appointment)),
                      );
                    },
                    child:
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            "7/1/2023",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 20.sp),
                          Expanded(
                            child: Text(
                              "Viral flu",
                              style: TextStyle(fontSize: 14.0, color: Colors.grey[800]),
                            ),
                          ),
                          Icon(Icons.access_time, size: 20.0, color: Colors.amberAccent),

                        ],
                      ),
                    ),
                  ),

                  // Container 6
                  InkWell(
                    onTap: () {
                      Appointments appointment = Appointments(
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
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientHistoryDetails(appointment: appointment)),
                      );
                    },
                    child:
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            "2/1/2023",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 20.sp),
                          Expanded(
                            child: Text(
                              "EMR not available",
                              style: TextStyle(fontSize: 14.0, color: Colors.grey[500]),
                            ),
                          ),
                          Icon(Icons.access_time, size: 20.0, color: Colors.amberAccent),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


