import 'package:flutter/material.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/screens/about/self_help_screen.dart';

import '../../Model/Appointment/GetAppointments.dart';
import '../../constants/Constant.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/drawer.dart';
import '../../widgets/searchbar.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  _HelpSupportScreenState createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedSupportType;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  bool isRequestCallback = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isABDMEnabled = true;

  final List<Map<String, String>> supportTypes = [
    {'id': '0', 'name': 'Select Any'},
    {'id': '1', 'name': 'Add medicine to database'},
    {'id': '2', 'name': 'Add missing lab test'},
    {'id': '3', 'name': 'Add user or doctor'},
    {'id': '4', 'name': 'Add / Update Rates'},
    {'id': '5', 'name': 'Add / Update Doctor Timing'},
    {'id': '6', 'name': 'Add / Update Clinic Timing'},
    {'id': '7', 'name': 'Training Request'},
    {'id': '8', 'name': 'Patient Not registering'},
    {'id': '9', 'name': 'Login not working'},
    {'id': '10', 'name': 'Patient not found'},
    {'id': '11', 'name': 'Appointment not registering'},
    {'id': '12', 'name': 'Other'},
  ];


  final Map<String, List<String>> selfHelpContent = {
    "Appointments": [
      "How to book an appointment for a new patient?",
      "How to book an appointment for an existing patient?",
      "How to book an appointment with ABHA?",
      "How to update patient details when adding an appointment?",
      "How to reschedule or cancel an appointment?",
      "How to view the daily visit list?",
      "How to view upcoming visit list?",
      "How to view past visit list?",
    ],
    "Patients": [
      "How to search for a patient and see their complete medical record?",
      "How to view patient records via ABDM?",
    ],
    "Bills": [
      "How to pay a pending bill?",
      "How to access patient bills?",
      "How to check pending payments for the day?",
    ],
    "ABHA": [
      "How to create ABHA for new patients?",
      "How to link a patient’s existing ABHA with an appointment?",
      "How to link ABHA for a completed consultation?",
    ],
    "EMR (Electronic Medical Record)": [
      "How to upload an Rx and complete a consultation?",
      "How to add clinical notes and complete a consultation?",
      "How to consult using the Voice analyzer?",
      "How to view prescription or consultation information for the patient?",
      "How to send prescription or consultation information to the patient via WhatsApp?",
      "How to create pre-set prescription templates?",
      "How to create test recommendation lists?",
    ],
    "Teleconsultation": [
      "How to add and complete a tele-consult?",
      "How to enable tele-consultation?",
    ],
    "Settings": [
      "How to change account password?",
      "How to change account PIN?",
      "How to consult in multiple clinics?",
      "How to switch between clinics?",
      "How to set the primary consultation type?",
      "How to setup biometric login?",
    ],
    "MIS (Management Information System)": [
      "How to check clinic insights?",
    ],
  };

  // Method to show the video player in a dialog
  void _showVideoDialog(String videoUrl) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing the dialog by tapping outside
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: VideoPlayerDialog(videoUrl: videoUrl),
        );
      },
    );
  }

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
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
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
      drawer: ArgonDrawer(currentPage: Constant.help),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(0.0),
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

            // Self Help Content
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.separated(
                    itemCount: selfHelpContent.entries.length,
                    separatorBuilder: (context, index) => Divider(
                      color: ArgonColors.muted, // Custom color for the divider
                      thickness: 1.0, // Divider thickness
                      height: 10.0, // Space between the tiles
                    ),
                    itemBuilder: (context, index) {
                      final entry = selfHelpContent.entries.elementAt(index);
                      return ExpansionTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: ArgonColors.primary,
                          ),
                        ),
                        tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
                        childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: entry.value.map((item) {
                          return ListTile(
                            title: Text(
                              item,
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            leading: IconButton(
                              icon: const Icon(Icons.play_circle_outline_sharp),
                              onPressed: () {
                                _showVideoDialog('https://connectstaging.medixcel.in/self_help_videos/How_to_book_an_appointment_for_a_new_patient.mp4');
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
            // // Elevated Button at the Bottom
            // Padding(
            //   padding: const EdgeInsets.only(top: 16.0),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       _showVideoDialog('https://connectstaging.medixcel.in/self_help_videos/How_to_book_an_appointment_for_a_new_patient.mp4');
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: ArgonColors.primary,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       minimumSize: Size(100, 50), // Width: 100, Height: 50
            //     ),
            //     child: Text(
            //       'Video',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 13,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType? keyboardType,
        int maxLines = 1,
        String? Function(String?)? validator,
      }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: TextStyle(fontSize: 10,
                fontWeight:FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            validator: validator,
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String label,
      List<Map<String, String>> items,
      Function(String?) onChanged,
      ) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: selectedSupportType,
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty || value == '0') {
                return 'Please select a support type *';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: items.map((supportType) {
              return DropdownMenuItem<String>(
                value: supportType['id'],
                child: Text(supportType['name']!, style: TextStyle(fontSize: 10)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success', style: TextStyle(fontSize: 10)),
          content: Text('Your support request has been sent successfully!', style: TextStyle(fontSize: 10)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK', style: TextStyle(fontSize: 10)),
            ),
          ],
        );
      },
    );
  }
}
