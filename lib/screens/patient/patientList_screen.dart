import 'package:flutter/material.dart';
import 'package:outpatient_department/constants/utils.dart';
import 'package:outpatient_department/screens/patient/add_patient_screen.dart';
import 'package:outpatient_department/screens/patient/patient_details.dart';
import 'package:outpatient_department/screens/patient/patient_history_screen.dart';
import 'package:outpatient_department/widgets/drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/Appointment/GetAppointments.dart';
import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/navbar.dart';
import '../../widgets/searchbar.dart';

class PatientlistScreen extends StatefulWidget {
  const PatientlistScreen({super.key});

  @override
  State<PatientlistScreen> createState() => _PatientlistScreenState();
}

class _PatientlistScreenState extends State<PatientlistScreen> {
  List<Patient> allPatients = [
    Patient(
      name: 'Ramesh Sawant',
      patientNo: 'PU-B92-AAA5401',
      avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      age: "27",
      gender: 'M',
      ABHA: 'Rameshsawant@abdm',
      mobile: '7385679928',
    ),
    Patient(
      name: 'Manoj Wagh',
      patientNo: 'PU-B92-AAA5402',
      avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      age: "23",
      gender: 'M',
      ABHA: 'Manojwagh@abdm',
      mobile: '7367679928',
    ),
    Patient(
      name: 'Riya Deore',
      patientNo: 'PU-B92-AAA5403',
      avatarUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
      age: "25",
      gender: 'F',
      ABHA: 'Riyadeore@abdm',
      mobile: '7385679898',
    ),
  ];
  List<Patient> filteredPatients = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isABDMEnabled = true;

  TextEditingController _searchPatientController = TextEditingController();
  Appointments? selectedPatient;
  List<Appointments> filteredPatientData = [];
  bool searchFlag = false;
  @override
  void initState() {
    super.initState();
    filteredPatients = allPatients;
    filteredPatientData = Constant.samplePatientData;
    _searchPatientController.addListener(_filterAppointments);
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
      backgroundColor: ArgonColors.primary,
      drawer: ArgonDrawer(currentPage: Constant.patient),
      body: Column(
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
          /* Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                          controller: _searchController,
                          style:TextStyle(fontSize:13),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Search Patient by Name, mobile, ABHA',
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
              ],
            ),
          ),*/
          // SizedBox(height: 20),
          Expanded(
            child: Container(
              color: Colors.white,
              /* decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),*/
              child: filteredPatients.length == 0 ?
              Center(
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
                      "You have no patients yet",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              )
                  :ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  return PatientCard(
                    name: filteredPatients[index].name,
                    patient_no: filteredPatients[index].patientNo,
                    avatarUrl: filteredPatients[index].avatarUrl,
                    age: filteredPatients[index].age,
                    gender: filteredPatients[index].gender,
                    ABHA: filteredPatients[index].ABHA,
                    mobile: filteredPatients[index].mobile,
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
                MaterialPageRoute(builder: (context) => const AddPatientScreen()),
              );
            },
            label: Padding(
              padding: EdgeInsets.all(0),
              child: Text(
                'Add Patients',
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

class Patient {
  final String name;
  final String patientNo;
  final String age;
  final String gender;
  final String avatarUrl;
  final String ABHA;
  final String mobile;

  Patient({
    required this.name,
    required this.patientNo,
    required this.age,
    required this.gender,
    required this.avatarUrl,
    required this.ABHA,
    required this.mobile,
  });
}

class PatientCard extends StatelessWidget {
  final String name;
  final String patient_no;
  final String age;
  final String gender;
  final String avatarUrl;
  final String ABHA;
  final String mobile;

  const PatientCard({
    required this.name,
    required this.patient_no,
    required this.age,
    required this.gender,
    required this.avatarUrl,
    required this.ABHA,
    required this.mobile,
  });

  Future<void> requestCallPermission(BuildContext context) async {
    if (await Permission.phone.request().isGranted) {
      await dialNumber(phoneNumber: mobile, context: context);
    } else {
      Utils.showToastMessage('Phone call permission denied.');
    }
  }

  Future<void> dialNumber({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    final url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } catch (e) {
        Utils.showToastMessage('Error: Unable to initiate call');
      }
    } else {
      Utils.showToastMessage('Unable to call $phoneNumber. No suitable app found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Appointments appointment = new Appointments();
        appointment.name=name;
        appointment.age= num.parse(age);
        appointment.gender=gender;
        appointment.mobile=mobile;
        appointment.ageType == 'Years';
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientHistoryScreen(appointment: appointment)),
        );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
                    Container(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: avatarUrl.isNotEmpty
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: avatarUrl.isEmpty
                            ? Text(
                          name[0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        )
                            : null,
                      ),),

                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                ' - ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                gender,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "/",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                age,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            patient_no,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            ABHA,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            mobile,
                            style: TextStyle(
                              fontSize: 12,
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
          ),
        ],
      ),
    );
  }

}
