import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outpatient_department/Model/Appointment/GetAppointments.dart';
import 'package:outpatient_department/Model/Login/VerifyOTPResponse.dart';
import 'package:outpatient_department/constants/Constant.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/screens/appointment/appointment_screen.dart';

import 'package:outpatient_department/screens/appointment/consultation_photo.dart';
import 'package:outpatient_department/screens/appointment/consultation_voice.dart';
import 'package:outpatient_department/widgets/app_bar.dart';
import 'package:outpatient_department/widgets/drawer.dart';

import '../../constants/utils.dart';
import '../../widgets/searchbar.dart';


class ManualConsultationScreen extends StatefulWidget {
  final Appointments appointment;
  const ManualConsultationScreen({super.key,required this.appointment});

  @override
  State<ManualConsultationScreen> createState() =>
      _ManualConsultationScreenState();
}

class _ManualConsultationScreenState extends State<ManualConsultationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //var doctorname = '', clinicName = '';
  bool isABDMEnabled = true;
  String _userInputText = '';
  bool isSummaryExpanded = false;
  List<File> _uploadedFiles = []; // To store uploaded files
  final ImagePicker _picker = ImagePicker();
  final box = GetStorage();
  final List<String> _medicineList = [
    'Paracetamol (Calpol 650)',
    'Pantoprazole (PanD-40)',
    'Ibuprofen',
    'Amoxicillin',
  ];
  final List<Map<String, String>> icd10Data = [
    {'code': 'KD11', 'description': 'Fever of newborn'},
    {'code': 'MG26', 'description': 'Fever of other or unknown origin'},
    {'code': 'R50.9', 'description': 'Fever, unspecified'},
    {'code': '1A07', 'description': 'Typhoid fever'},
    {'code': '1Af7', 'description': 'Typhoid fever'},
    {'code': '1A67', 'description': 'Typhoid fever'},
    {'code': '1S37', 'description': 'Typhoid fever'},
    {'code': '1N87', 'description': 'Typhoid fever'},
    {'code': '1M07', 'description': 'Typhoid fever'},
    {'code': '1A97', 'description': 'Typhoid fever'},
    {'code': '1B41', 'description': 'Acute rheumatic fever without mention of heart involvement'},
  ];

  List<Map<String, String>> filteredData = [];
  final List<Map<String, String>> _selectedMedicines = [];
  String _searchQuery = '';


  void _showVitalsDialog(BuildContext context) {
    TextEditingController tempController = TextEditingController();
    TextEditingController hrController = TextEditingController();
    TextEditingController bmiController = TextEditingController();
    TextEditingController rrController = TextEditingController();
    TextEditingController bpController1 = TextEditingController();
    TextEditingController bpController2 = TextEditingController();
    TextEditingController htController = TextEditingController();
    TextEditingController wtController = TextEditingController();
    TextEditingController rbsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vitals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),

                // Row with Titles and Input Fields
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Temp', style: TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: tempController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(width: 30,),
                    Expanded(
                      flex: 2,
                      child: Text('Ht', style: TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: htController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Repeat similar structure for other fields
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('HR', style: TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: hrController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(width: 30,),
                    Expanded(
                      flex: 2,
                      child: Text('Wt', style: TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: wtController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('RR', style: TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: rrController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(width: 30,),
                    Expanded(
                      flex: 2,
                      child: Text('BMI', style: TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: bmiController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('BP', style: TextStyle(fontSize: 14)),
                    ),
                   // SizedBox(width: 30,),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: htController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                   /* Expanded(
                      flex: 1,
                      child: TextField(
                        controller: bpController1,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Text('/', style: TextStyle(fontSize: 14)),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: bpController2,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),*/
                    SizedBox(width: 30,),

                    Expanded(
                      flex: 2,
                      child: Text('RBS', style: TextStyle(fontSize: 14)),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: rbsController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Vitals Submitted');
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  ArgonColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _showMedicineDialog(String medicine) {
    final TextEditingController frequencyController = TextEditingController();
    final TextEditingController daysController = TextEditingController();
    final TextEditingController doseController = TextEditingController();
    final TextEditingController instructionsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Add Details for $medicine',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Frequency',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: frequencyController,
                        decoration: InputDecoration.collapsed(hintText:null),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Days Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Days',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: daysController,
                        decoration: InputDecoration.collapsed(hintText:null),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Dose
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Dose',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: doseController,
                        decoration: InputDecoration.collapsed(hintText:null),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Instructions Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Instructions',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: instructionsController,
                        decoration: InputDecoration.collapsed(hintText: null),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color:ArgonColors.primary, fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedMedicines.add({
                    'name': medicine,
                    'frequency': frequencyController.text,
                    'days': daysController.text,
                    'instructions': instructionsController.text,
                  });
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ArgonColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, String>> selectedItems = [];
  void showICD10Dialog() async {
    List<Map<String, String>> filteredData = []; // Initially empty

    // Await the result from the dialog
    final result = await showDialog<List<Map<String, String>>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select ICD-10 Codes',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(selectedItems);
                        },
                      ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: TextStyle(fontSize: 16),
                          suffixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.length >= 3) {
                              filteredData = icd10Data
                                  .where((item) => item['description']!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                                  .toList();
                            } else {
                              filteredData = [];
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: filteredData.isEmpty
                          ? Center(
                        child: Text(
                          'No ICD-10 Code found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 12,
                          headingRowHeight: 40,
                          dataRowHeight: 50,
                          columns: [
                            DataColumn(
                              label: Text(
                                'S.No',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Code',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Description',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Action',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                          rows: filteredData
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            var item = entry.value;
                            bool isSelected = selectedItems.contains(item);

                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    '${index + 1}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['code']!,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      item['description']!,
                                      style: TextStyle(fontSize: 14),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: Icon(
                                      isSelected
                                          ? Icons.remove
                                          : Icons.add,
                                      color: isSelected
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedItems.remove(item);
                                        } else {
                                          selectedItems.add(item);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedItems = result;
      });
    }
  }


  TextEditingController _searchPatientController = TextEditingController();
  Appointments? selectedPatient;
  List<Appointments> filteredPatientData = [];
  bool searchFlag = false;
  @override
  void initState() {
    filteredData = List.from(icd10Data);
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
                                  appointment.name!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5.0.sp),
                                Text(
                                  appointment.gender!,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '/${appointment.age!} ${appointment.ageType == 'Years' ? '' : appointment.ageType}',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                if (appointment
                                    .teleconsultationTypeId ==
                                    1)
                                  Icon(
                                    Icons.videocam,
                                    color: Color(0xFF333333),
                                    size: 12.sp,
                                  ),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              appointment.mobile ?? '',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        if (appointment.mobile != null && appointment.mobile!.isNotEmpty)
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
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                _showVitalsDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ArgonColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(30, 30), // Width: 100, Height: 50

                              ),
                              child: Text(
                                'Vitals',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        if (isSummaryExpanded)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Visited 15 days ago for hypertension and high cholesterol. Often complains of headaches and dizziness (6 visits this year). "
                                  "Takes Amlodipine 5 mg and Atorvastatin 20 mg. Allergic to penicillin and peanuts. Has Type 2 Diabetes for 10 years.\n"
                                  "Smokes 5 cigs/day, drinks alcohol occasionally. Family history of heart disease and diabetes. BP: 150/90, BMI: 28. "
                                  "Needs diet changes and to quit smoking for better health.",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),

                        SizedBox(
                          height: 16,
                        ),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complaints',
                              style:
                              TextStyle(color: ArgonColors.primary, fontSize: 16,                              fontWeight: FontWeight.bold,
                              ),
                            ),
                            /*SizedBox(width: 16),*/

                          ],
                        ),
                        Container(
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                maxLines: 4,
                                decoration: InputDecoration.collapsed(
                                  hintText: null,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Diagnosis',
                              style: TextStyle(
                                color:ArgonColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: showICD10Dialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ArgonColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(30, 30), // Width: 100, Height: 50

                              ),
                              child: Text(
                                'ICD-10',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),

                            /*Column(
                              children: [

                              ],
                            ),
                            SizedBox(width: 16),*/

                          ],
                        ),
                        Container(
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                maxLines: 4,
                                decoration: InputDecoration.collapsed(
                                  hintText: null,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedItems
                              .map((item) => Chip(
                            label: Text(
                              item['code']!,
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey),
                            ),
                            onDeleted: () {
                              setState(() {
                                selectedItems.remove(item);
                              });
                            },
                          ))
                              .toList(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prescription',
                              style:
                              TextStyle(color: ArgonColors.primary, fontSize: 16,fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 240.sp,
                              width: double.infinity,
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Search Bar
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  _searchQuery = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Search medicines.",
                                                hintStyle: TextStyle(color: Colors.grey),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Icon(Icons.search, color: Colors.grey),
                                        ],
                                      ),
                                      Divider(color: Colors.grey[300], thickness: 1),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              _userInputText = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: null,
                                            border: InputBorder.none,
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                      if (_searchQuery.isNotEmpty)
                                        Expanded(
                                          child: ListView(
                                            children: _medicineList
                                                .where((medicine) =>
                                                medicine.toLowerCase().contains(_searchQuery.toLowerCase()))
                                                .map((medicine) => ListTile(
                                              title: Text(medicine),
                                              onTap: () {
                                                _showMedicineDialog(medicine);
                                                setState(() {
                                                  _searchQuery = "";
                                                });
                                              },
                                            ))
                                                .toList(),
                                          ),
                                        ),
                                      Spacer(),
                                      if (_selectedMedicines.isNotEmpty)
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(8.0),
                                          color: Colors.grey[200],
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: _selectedMedicines.map((medicine) {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Text(
                                                  '${medicine['name']} - ${medicine['frequency']}, ${medicine['days']}, ${medicine['instructions']}',
                                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 12),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Advice',
                                  style:
                                  TextStyle(color: ArgonColors.primary, fontSize: 16,                              fontWeight: FontWeight.bold,
                                  ),
                                ),
                                /*SizedBox(width: 16),*/

                              ],
                            ),
                            Container(
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    maxLines: 4,
                                    decoration: InputDecoration.collapsed(
                                      hintText: null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 200),
                ],
              ),
            ),
          ),
          // Floating Buttons
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VoiceConsultationScreen(appointment: appointment)),
                    );
                  },
                  child: Icon(
                    Icons.mic,
                    color: ArgonColors.primary,
                    size: 40.0,
                  ),
                ),
                SizedBox(height: 12.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConsultationPhotoScreen(appointment: appointment)),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    color: ArgonColors.primary,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}