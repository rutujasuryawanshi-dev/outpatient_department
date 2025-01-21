import 'package:flutter/material.dart';
import 'package:outpatient_department/constants/utils.dart';

import '../Model/Appointment/GetAppointments.dart';
import '../constants/Constant.dart';
import '../constants/Theme.dart';
import '../screens/patient/patientList_screen.dart';
import '../screens/patient/patient_history_screen.dart';

class SearchAppointmentWidget extends StatefulWidget {
  final Function(Appointments?) onAppointmentSelected;
  final TextEditingController searchController;
  final List<Appointments> filteredAppointments;
  final Appointments? selectedAppointment;

  const SearchAppointmentWidget({
    Key? key,
    required this.onAppointmentSelected,
    required this.searchController,
    required this.filteredAppointments,
    this.selectedAppointment,
  }) : super(key: key);

  @override
  _SearchAppointmentWidgetState createState() =>
      _SearchAppointmentWidgetState();
}

class _SearchAppointmentWidgetState extends State<SearchAppointmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ArgonColors.primary,
      ),
      child: Padding(
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
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: DropdownMenu<Appointments>(
                      controller: widget.searchController,
                      textStyle: TextStyle(color: Colors.black, fontSize: 12),
                      width: 340,
                      hintText: widget.selectedAppointment == null
                          ? "Search Patient by Name, mobile, ABHA"
                          : "Search Patient by Name, mobile, ABHA",
                      selectedTrailingIcon: GestureDetector(
                        onTap: () {
                          if(widget.searchController.text.isNotEmpty){
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
                          if(widget.searchController.text.isNotEmpty){
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
                        widget.onAppointmentSelected(appointment);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PatientHistoryScreen(appointment: appointment)),
                        );
                      },
                      dropdownMenuEntries: widget.filteredAppointments
                          .map<DropdownMenuEntry<Appointments>>(
                              (Appointments appointment) {
                            return DropdownMenuEntry<Appointments>(
                              value: appointment,
                              label: appointment.name ?? "No name available",
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Constant.searchFlag = false;
                widget.onAppointmentSelected(null);
              },
            ),
          ],
        ),
      ),
    );
  }
}
