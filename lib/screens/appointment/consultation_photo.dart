import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outpatient_department/Model/Appointment/GetAppointments.dart';
import 'package:outpatient_department/Model/Login/VerifyOTPResponse.dart';
import 'package:outpatient_department/constants/Constant.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/screens/appointment/consultation_voice.dart';
import 'package:outpatient_department/widgets/app_bar.dart';
import 'package:outpatient_department/widgets/drawer.dart';

import '../../constants/utils.dart';
import '../../widgets/searchbar.dart';
import 'appointment_screen.dart';
import 'consultation_manual.dart';

class ConsultationPhotoScreen extends StatefulWidget {
  final Appointments appointment;

  const ConsultationPhotoScreen({super.key,required this.appointment});

  @override
  State<ConsultationPhotoScreen> createState() => _UploadeConsultationScreenState();
}

class _UploadeConsultationScreenState extends State<ConsultationPhotoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //var doctorname='', clinicName = '';
  bool isABDMEnabled = true;
  bool isSummaryExpanded = false;
  List<File> _uploadedFiles = []; // To store uploaded files
  final ImagePicker _picker = ImagePicker();
  final box = GetStorage();



  Future<void> _showUploadDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Upload File"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _uploadedFiles.add(File(pickedFile.path));
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.green),
                title: Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _uploadedFiles.add(File(pickedFile.path));
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.file_copy_outlined, color: Colors.red),
                title: Text("Document"),
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    setState(() {
                      _uploadedFiles.add(file);
                    });
                  }
                },
              ),
            ],
          ),
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
    VerifyOtpResponse? verifyOtpResponse;
    var loginresponse = box.read(Constant.loginResponse);
    var  selectedClinic = box.read(Constant.selectedClinic);

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
      ),      body: Stack(
      children: [
        // Main Content
        Container(
          color: Colors.white,
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
                padding: const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 4.0, right: 12.0),
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
                          // Handle phone icon tap
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
              if (_uploadedFiles.isNotEmpty)
                Container(
                  height: 50.0,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _uploadedFiles.length,
                    itemBuilder: (context, index) {
                      var file = _uploadedFiles[index];
                      return Container(
                        width: 50.sp,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                          image: file.path.endsWith(".pdf")
                              ? null
                              : DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (file.path.endsWith(".pdf"))
                              Center(
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            Positioned(
                              right: -16,
                              top: -16,
                              child: IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _uploadedFiles.remove(file);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _showUploadDialog,
                      child: Column(
                        children: [
                          Icon(Icons.add_circle, size: 150, color: ArgonColors.primary),
                          SizedBox(height: 8.0),
                          Text(
                            "Click to select file & upload",
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              if (_uploadedFiles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(19.0),
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ArgonColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Upload Files",
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ),
            ],
          ),
        ),
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
                      builder: (context) => ManualConsultationScreen(appointment: appointment),
                    ),
                  );
                },
                child: Icon(
                  Icons.note_add,
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
