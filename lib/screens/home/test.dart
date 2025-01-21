import 'package:flutter/material.dart';
import 'package:outpatient_department/constants/Theme.dart';

import '../../Model/Appointment/GetAppointments.dart';

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
];

class DropdownMenuSample extends StatefulWidget {
  const DropdownMenuSample({super.key});
  @override
  State<DropdownMenuSample> createState() => _DropdownMenuSampleState();
}

class _DropdownMenuSampleState extends State<DropdownMenuSample> {

  Appointments? selected;

  @override
  Widget build(BuildContext context) {
    final TextEditingController menuController = TextEditingController();

    return Scaffold(
      backgroundColor: ArgonColors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50.0,
            ),
            DropdownMenu<Appointments>(
              controller: menuController,
              width: 300,
              hintText: selected == null ? "Search Patient by Name, mobile, ABHA" : selected!.name,
              selectedTrailingIcon:  Icon(
                Icons.search_outlined,
                color: ArgonColors.primary,
              ),
              trailingIcon: Icon(
                Icons.search_outlined,
                color: ArgonColors.primary,
              ),
              inputDecorationTheme:
              InputDecorationTheme(
                // border: InputBorder.none,

                hintStyle:TextStyle(color: ArgonColors.black,fontSize: 12) ,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ArgonColors
                          .primary,
                    )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ArgonColors
                          .primary,
                    )),

              ),
              requestFocusOnTap: true,
              enableFilter: true,
              menuStyle: MenuStyle(


                backgroundColor: MaterialStateProperty.all<Color>(ArgonColors.white),
              ),
              //label: const Text('Select Patient',style: TextStyle(fontSize: 12),),
              onSelected: (Appointments? appointment) {
                setState(() {
                  selected = appointment;
                  menuController.text = appointment?.name ?? '';
                });
              },
              dropdownMenuEntries: sampleAppointments
                  .map<DropdownMenuEntry<Appointments>>(
                      (Appointments appointment) {
                    return DropdownMenuEntry<Appointments>(
                      value: appointment,
                      label: appointment.name!,
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
