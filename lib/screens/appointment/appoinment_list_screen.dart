import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/screens/appointment/appoinment_details_screen.dart';
import 'package:outpatient_department/screens/appointment/appointment_screen.dart';
import 'package:outpatient_department/screens/appointment/consultation_manual.dart';
import 'package:outpatient_department/screens/appointment/consultation_photo.dart';
import 'package:outpatient_department/screens/appointment/consultation_voice.dart';
import 'package:outpatient_department/widgets/drawer.dart';
import 'package:outpatient_department/widgets/navbar.dart';

import '../../constants/Constant.dart';
import '../../constants/utils.dart';

class AppoinmentListScreen extends StatefulWidget {
  const AppoinmentListScreen({super.key});

  @override
  State<AppoinmentListScreen> createState() => _AppoinmentListScreenState();
}

class _AppoinmentListScreenState extends State<AppoinmentListScreen> {
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  final List<Map<String, String>> appointments = [
    {
      'time': '16:30 AM',
      'name': 'Raj Deore',
      'details': 'Consultation(General Practice)',
      'status':
      'Booked',
    },
    {
      'time': '10:30 AM',
      'name': 'Smita Wagh',
      'details': 'Consultation(Dentist)',
      'status': 'Late',
    },
    {
      'time': '12:00 PM',
      'name': 'Kunal Gunjal',
      'details': 'Consultation(Cardiology)',
      'status': 'Completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: Constant.appointments,
        transparent: true,
      ),
      backgroundColor: ArgonColors.primary,
      drawer: ArgonDrawer(currentPage: Constant.appointments),
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50.0,
              child: Container(
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Patient name, test name',
                      suffixIcon: Icon(
                        Icons.search,
                        color: ArgonColors.primary,
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
          ),
          SizedBox(height: 20),
          // Appointment List
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    vertical: 33.0, horizontal: 16.0),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  Color appointmentColor;

                  // Determine the color based on the appointment status
                  switch (appointment['status']) {
                    case 'Booked':
                      appointmentColor =
                          Colors.white;
                      break;
                    case 'Late':
                      appointmentColor =
                          Colors.orange.shade100;
                      break;
                    case 'Completed':
                      appointmentColor =
                          Colors.lightGreen.shade100;
                      break;
                    default:
                      appointmentColor =
                          Colors.white;
                      break;
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),

                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: appointmentColor,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              appointment['time']!,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 16.0.sp),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {

                                        },
                                        child: Text(
                                          appointment['name']!,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),


                                      SizedBox(width: 4.0),
                                      Text(
                                        'M/55 years',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0.sp),
                                  Text(
                                    appointment['details']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 27.0),
        child: Container(
          height: 50.0,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppointmentScreen(appointments: null,)),
              );
            },
            label: Padding(
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
              child: Text(
                'Book Appointment',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 13,
            ),
            backgroundColor: ArgonColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
      ),
    );
  }
}
