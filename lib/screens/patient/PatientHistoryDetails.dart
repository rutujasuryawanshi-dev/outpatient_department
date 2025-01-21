import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Model/Appointment/GetAppointments.dart';
import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../constants/utils.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/drawer.dart';
import '../../widgets/searchbar.dart';

class PatientHistoryDetails extends StatefulWidget {
  final Appointments? appointment;

  const PatientHistoryDetails({super.key, required this.appointment});

  @override
  State<PatientHistoryDetails> createState() => _PatientHistoryDetailsState();
}

class _PatientHistoryDetailsState extends State<PatientHistoryDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isABDMEnabled = true;

  final List<Map<String, String>> drugData = [
    {
      "name": "CALPOL(Paracetamol)[500 mg|Tablet]",
      "dosage": "1|BDS",
      "days": "3 Days",
    },
    {
      "name": "CIPROBID(Ciprofloxacin)[250 mg|Tablet/Syrup]",
      "dosage": "1|BID",
      "days": "3 Days",
    },
    {
      "name": "ELECTRAL(Electrolyte)[|Powder]",
      "dosage": "1|OD",
      "days": "1 Day",
    },
  ];

  TextEditingController _searchPatientController = TextEditingController();
  Appointments? selectedPatient;
  List<Appointments> filteredPatientData = [];
  bool searchFlag = false;
  @override
  void initState() {
    super.initState();
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
          Container(
            color: ArgonColors.white,
            child: SingleChildScrollView(
              child: Column(children: [
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

                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: ArgonColors.border),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Consultation Details : 104374",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ArgonColors.primary,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.picture_as_pdf,
                                    color: ArgonColors.black,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.close,
                                    color: ArgonColors.border,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(color: ArgonColors.border, thickness: 1),
                        SizedBox(height: 16.h),
                        _buildSectionHeader("Lifewave Health"),
                        SizedBox(height: 16.h),

                        _buildRowDetails("Visit Date:", "06-12-2024"),
                        SizedBox(height: 16.h),
                        _buildSectionHeader("Dr. Annesha Das (MBBS, MD)"),
                        SizedBox(height: 16.h),
                        _buildRowDetails("Patient:", "Anusha Das"),
                        _buildRowDetails("Service:", "Consultation"),
                        SizedBox(height: 16.h),
                        _buildSectionHeader("Complaints"),
                        SizedBox(height: 8.h),
                        _buildComplaintDetails("Fever", "1 day"),
                        _buildComplaintDetails("Loose motion", "1 day"),
                        SizedBox(height: 16.h),
                        _buildSectionHeader("Vitals"),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.all(6.w),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Table(
                              border: TableBorder(
                                horizontalInside: BorderSide(color:ArgonColors.border, width: 1),
                              ),
                              columnWidths: const <int, TableColumnWidth>{
                                0: FixedColumnWidth(160), // Adjust the width of the first column
                                1: FixedColumnWidth(160),
                              },
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              children: [
                                // Table Header
                                TableRow(
                                  children: [
                                    _buildTableCell("Vital Name", isHeader: true),
                                    _buildTableCell("06-12-2024 11:33:36", isHeader: true),

                                  ],
                                ),
                                // Example Rows
                                _buildTableRow("Temp", "99 F"),
                                _buildTableRow("BP Systolic","100 mmHg"),
                                _buildTableRow("BP Diastolic", "78 mmHg"),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),
                        _buildSectionHeader("Doctor Notes"),
                        SizedBox(height: 8.h),
                        _buildDetails("Drink 9 glasses of water.Drink lots of fluid.Avoid dairy and oily food."),

                        SizedBox(height: 16.h),
                        _buildSectionHeader("Prescription"),
                        SizedBox(height: 8.h),

                        Padding(
                          padding: EdgeInsets.all(6.w),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Table Header
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 170,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Drug Name [Strength | Formulation]",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.sp,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Dosage | Frequency",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.sp,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Days",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.sp,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.grey, thickness: 1), // Horizontal Line
                                  ],
                                ),
                                // Table Content
                                ...drugData.map((drug) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 170,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            drug["name"]!,
                                            style: TextStyle(fontSize: 10.sp,color:  Colors.grey.shade600),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            drug["dosage"]!,
                                            style: TextStyle(fontSize: 10.sp,color:  Colors.grey.shade600),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            drug["days"]!,
                                            style: TextStyle(fontSize: 10.sp,color:  Colors.grey.shade600),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),


                        SizedBox(height: 16.h),
                        _buildSectionHeader("Diagnosis"),
                        SizedBox(height: 8.h),
                        _buildDetails("diarrhea"),
                        _buildDetails("ICD10:R19.7:Diarrhea,unspecified"),

                        SizedBox(height: 16.h),
                        _buildSectionHeader("Recommendations"),
                        SizedBox(height: 8.h),
                        _buildDetails("blood test,stool test"),

                        SizedBox(height: 16.h),
                        _buildSectionHeader("Followup"),
                        SizedBox(height: 8.h),
                        _buildDetails("Date:13-12-2024"),


                      ],
                    ),
                  ),
                ),
              ],),
            ),


          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        color: ArgonColors.black,
      ),
    );
  }

  Widget _buildRowDetails(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: ArgonColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildComplaintDetails(String complaint, String duration) {
    return Text(
      "$complaint --> $duration",
      style: TextStyle(
        fontSize: 10.sp,
        color: Colors.grey.shade600,
      ),
    );
  }
  Widget _buildDetails(String details) {
    return Text(
      "$details",
      style: TextStyle(
        fontSize: 10.sp,
        color: Colors.grey.shade600,
      ),
    );
  }
  TableRow _buildTableRow(String date, String patient) {
    return TableRow(
      children: [
        _buildTableCell(date),
        _buildTableCell(patient),

      ],
    );
  }

  Widget _buildTableCell(String content, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? ArgonColors.primary : Colors.black,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }




}
