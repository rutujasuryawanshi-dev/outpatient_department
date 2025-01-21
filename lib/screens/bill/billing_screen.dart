import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../Model/Appointment/GetAppointments.dart';
import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../constants/utils.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/drawer.dart';
import '../../widgets/navbar.dart';
import '../../widgets/searchbar.dart';
import 'ViewBillingDetails.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final Map<String, bool> _expandedDates = {};

  List<Appointments>? appointmentList = [
    Appointments(
      scheduleId: 1,
      appointmentId: 101,
      date: "2025-01-14",
      time: "09:00 AM",
      name: "Krishiv Jadhav",
      gender: "Male",
      ageString: "35",
      ageType: "Years",
      age: 35,
      mobile: "1234567890",
      serviceType: "Consultation",
      service: "Dental Checkup",
      status: 1,
      doctorAlias: "Dr. Adams",
      billId: 201,
      teleconsultationTypeId: 1,
      pendingAmount: 50,
      isServiceCompleted: 0,
      consultationId: 301,
    ),
    Appointments(
      scheduleId: 2,
      appointmentId: 102,
      date: "2025-01-14",
      time: "09:00 AM",
      name: "Pratham Borse",
      gender: "Male",
      ageString: "35",
      ageType: "Years",
      age: 35,
      mobile: "1234567890",
      serviceType: "Consultation",
      service: "Dental Checkup",
      status: 1,
      doctorAlias: "Dr. Adams",
      billId: 201,
      teleconsultationTypeId: 1,
      pendingAmount: 50,
      isServiceCompleted: 1,
      consultationId: 301,
    ),
    Appointments(
      scheduleId: 3,
      appointmentId: 103,
      date: "2025-01-15",
      time: "10:30 AM",
      name: "Rashi Modi",
      gender: "Female",
      ageString: "28",
      ageType: "Years",
      age: 28,
      mobile: "1234567891",
      serviceType: "Therapy",
      service: "Physical Therapy",
      status: 1,
      doctorAlias: "Dr. Taylor",
      billId: 202,
      teleconsultationTypeId: 2,
      pendingAmount: 1000,
      isServiceCompleted: 1,
      consultationId: 302,
    ),
    Appointments(
      scheduleId: 4,
      appointmentId: 104,
      date: "2025-01-16",
      time: "11:00 AM",
      name: "Kavya More",
      gender: "Female",
      ageString: "42",
      ageType: "Years",
      age: 42,
      mobile: "1234567892",
      serviceType: "Consultation",
      service: "General Checkup",
      status: 2,
      doctorAlias: "Dr. Smith",
      billId: 203,
      teleconsultationTypeId: 3,
      pendingAmount: 100,
      isServiceCompleted: 0,
      consultationId: 303,
    ),
    Appointments(
      scheduleId: 5,
      appointmentId: 105,
      date: "2025-01-17",
      time: "02:00 PM",
      name: "Arya Shinde",
      gender: "Male",
      ageString: "50",
      ageType: "Years",
      age: 50,
      mobile: "1234567893",
      serviceType: "Surgery",
      service: "Minor Surgery",
      status: 1,
      doctorAlias: "Dr. Lopez",
      billId: 204,
      teleconsultationTypeId: 4,
      pendingAmount: 200,
      isServiceCompleted: 0,
      consultationId: 304,
    ),
  ];

  List<Appointments>? filteredAppointments = [];

  List<String> selectedFilters = [];
  bool isPaidSelected = false;
  bool isUnpaidSelected = false;
  bool isPartiallyPaidSelected = false;
  bool isDateSelected = false;

  DateTime? startDate;
  DateTime? endDate;

  final List<String> paymentModes = ['Cash', 'Card', 'UPI'];
  String selectedPaymentMode = 'Cash';
  num pendingAmount = 0;
  TextEditingController paymentController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isABDMEnabled = true;

  TextEditingController _searchPatientController = TextEditingController();
  Appointments? selectedPatient;
  List<Appointments> filteredPatientData = [];
  bool searchFlag = false;

  @override
  void initState() {
    super.initState();

    loadAppointments();

    setState(() {
      filteredAppointments = appointmentList;

      filteredPatientData = Constant.samplePatientData;
      _searchPatientController.addListener(_filterAppointments);
    });
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

  void loadAppointments() {
    DateTime now = DateTime.now();
    DateTime lastMonth = DateTime(now.year, now.month - 1, 1);

    appointmentList = appointmentList!.where((appointment) {
      DateTime appointmentDate = DateTime.parse(appointment.date!);
      return appointmentDate.isAfter(lastMonth) &&
          appointmentDate.isBefore(now.add(Duration(days: 1)));
    }).toList();
  }

  void showFilterPopup() {
    setState(() {
      isDateSelected = false;
      selectedFilters.remove("Date");
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Select Filters",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Paid", style: TextStyle(fontSize: 14)),
                            Checkbox(
                              value: isPaidSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  isPaidSelected = value!;
                                  if (value) {
                                    selectedFilters.add("Paid");
                                  } else {
                                    selectedFilters.remove("Paid");
                                  }
                                });
                              },
                              activeColor: ArgonColors.primary,
                              checkColor: ArgonColors.white,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Unpaid", style: TextStyle(fontSize: 14)),
                            Checkbox(
                              value: isUnpaidSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  isUnpaidSelected = value!;
                                  if (value) {
                                    selectedFilters.add("Unpaid");
                                  } else {
                                    selectedFilters.remove("Unpaid");
                                  }
                                });
                              },
                              activeColor: ArgonColors.primary,
                              checkColor: ArgonColors.white,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Partially Paid",
                                style: TextStyle(fontSize: 14)),
                            Checkbox(
                              value: isPartiallyPaidSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  isPartiallyPaidSelected = value!;
                                  if (value) {
                                    selectedFilters.add("Partially Paid");
                                  } else {
                                    selectedFilters.remove("Partially Paid");
                                  }
                                });
                              },
                              activeColor: ArgonColors.primary,
                              checkColor: ArgonColors.white,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Select Date", style: TextStyle(fontSize: 14)),
                            /* GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pop();
                                DateTimeRange? picked = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime.now().subtract(Duration(days: 30)),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    startDate = picked.start;
                                    endDate = picked.end;
                                  });
                                }
                              },
                              child: Icon(Icons.calendar_today, color: ArgonColors.primary),
                            ),
                            */
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isDateSelected = true!;

                                  selectedFilters.add("Date");
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Select Date Range",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                if (startDate != null &&
                                                    endDate != null)
                                                  Text(
                                                    "${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)}",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  )
                                                else if (startDate != null ||
                                                    endDate != null)
                                                  Text(
                                                    "${DateFormat('yyyy-MM-dd').format(startDate ?? endDate!)}",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                SizedBox(height: 10),
                                                CalendarDatePicker(
                                                  initialDate: startDate ??
                                                      DateTime.now(),
                                                  firstDate: DateTime.now()
                                                      .subtract(
                                                          Duration(days: 30)),
                                                  lastDate: DateTime.now(),
                                                  onDateChanged:
                                                      (DateTime date) {
                                                    setState(() {
                                                      if (startDate == null) {
                                                        startDate = date;
                                                      } else if (endDate ==
                                                              null &&
                                                          date.isAfter(
                                                              startDate!)) {
                                                        endDate = date;
                                                      } else if (endDate ==
                                                              null &&
                                                          date.isBefore(
                                                              startDate!)) {
                                                        endDate = startDate;
                                                        startDate = date;
                                                      } else {
                                                        startDate = date;
                                                        endDate = null;
                                                      }
                                                    });
                                                  },
                                                ),
                                                SizedBox(height: 10),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Save",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        ArgonColors.primary,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.calendar_today,
                                color: ArgonColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();

                        Map<String, bool> filterMap = {
                          "Paid": isPaidSelected,
                          "Unpaid": isUnpaidSelected,
                          "Partially Paid": isPartiallyPaidSelected,
                          "Date": isDateSelected,
                        };

                        applyFilters(filterMap);
                      },
                      child: Text(
                        'Apply',
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void applyFilters(Map<String, bool> filterMap) {
    setState(() {
      filteredAppointments = appointmentList;
    });

    if (filterMap["Paid"] == true) {
      filteredAppointments = filteredAppointments!
          .where((appointment) => appointment.isServiceCompleted == 1)
          .toList();
    }
    if (filterMap["Unpaid"] == true) {
      filteredAppointments = filteredAppointments!
          .where((appointment) => appointment.isServiceCompleted == 0)
          .toList();
    }
    if (filterMap["Partially Paid"] == true) {
      filteredAppointments = filteredAppointments!
          .where((appointment) => appointment.isServiceCompleted == 0)
          .toList();
    }

    if (filterMap["Date"] == true) {
      if (startDate != null && endDate != null) {
        filteredAppointments = filteredAppointments!.where((appointment) {
          DateTime appointmentDate =
              DateFormat("yyyy-MM-dd").parse(appointment.date!);
          return appointmentDate
                  .isAfter(startDate!.subtract(Duration(days: 1))) &&
              appointmentDate.isBefore(endDate!.add(Duration(days: 1)));
        }).toList();
      } else if (startDate != null) {
        filteredAppointments = filteredAppointments!.where((appointment) {
          DateTime appointmentDate =
              DateFormat("yyyy-MM-dd").parse(appointment.date!);
          return appointmentDate.isAtSameMomentAs(startDate!);
        }).toList();
      } else if (endDate != null) {
        filteredAppointments = filteredAppointments!.where((appointment) {
          DateTime appointmentDate =
              DateFormat("yyyy-MM-dd").parse(appointment.date!);
          return appointmentDate.isAtSameMomentAs(endDate!);
        }).toList();
      }
    }

    if (filterMap["Paid"] == false &&
        filterMap["Unpaid"] == false &&
        filterMap["Partially Paid"] == false &&
        filterMap["Date"] == false) {
      setState(() {
        filteredAppointments = appointmentList;
      });
    }

    setState(() {
      filteredAppointments = filteredAppointments;
    });
  }

  void showPaymentDialog(BuildContext context) {
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
                  'Pending Payment',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ArgonColors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('You have a pending amount ',
                        style: TextStyle(fontSize: 12)),
                    SizedBox(height: 10),
                    Text('Rs. ${pendingAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showAcceptPaymentDialog(context);
                      },
                      child: Text(
                        'Continue',
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
      backgroundColor: ArgonColors.white,
      drawer: ArgonDrawer(currentPage: Constant.billing),
      body: Stack(
        children: [
          Column(
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
              // SizedBox(height: 20),
              Expanded(
                child: Container(
                  /* decoration: BoxDecoration(
                    color: ArgonColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),*/
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: (filteredAppointments == null ||
                              filteredAppointments!.isEmpty)
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 200),
                                  Container(
                                    width: 250,
                                    child: Image.asset('assets/img/nodata.jpg'),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "You have no billing details",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ArgonColors.border,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(6.0),
                              itemCount: filteredAppointments!.length,
                              itemBuilder: (context, index) {
                                final appointment =
                                    filteredAppointments![index];

                                String appointmentDate = appointment.date!;
                                String displayDate = appointmentDate;

                                String yesterdayDate = DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()
                                        .subtract(Duration(days: 1)));

                                if (appointmentDate == yesterdayDate) {
                                  displayDate = 'Yesterday';
                                }

                                String todayDate = DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now());

                                if (appointmentDate == todayDate) {
                                  displayDate = 'Today';
                                }

                                /*pendingAmount = appointment.pendingAmount ?? 0;
                          paymentController.text=pendingAmount.toString();*/
                                _expandedDates.putIfAbsent(
                                    appointmentDate, () => true);

                                return Column(
                                  children: [
                                    if (index == 0 ||
                                        filteredAppointments![index - 1].date !=
                                            appointment.date)
                                      Row(
                                        children: [
                                          Text(
                                            displayDate,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              _expandedDates[appointmentDate]!
                                                  ? Icons.keyboard_arrow_down
                                                  : Icons.keyboard_arrow_up,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _expandedDates[
                                                        appointmentDate] =
                                                    !_expandedDates[
                                                        appointmentDate]!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    if (_expandedDates[appointmentDate]!)
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BillingDetailScreen(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 3.0),
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                              color: Colors.transparent,
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                blurRadius: 8.0,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (appointment
                                                              .isServiceCompleted ==
                                                          0) {
                                                        pendingAmount = appointment
                                                                .pendingAmount ??
                                                            0;
                                                        paymentController.text =
                                                            pendingAmount
                                                                .toString();
                                                        showPaymentDialog(
                                                            context);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 70,
                                                      child: Text(
                                                        'Rs ${appointment.pendingAmount}',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: appointment
                                                                        .isServiceCompleted ==
                                                                    1
                                                                ? ArgonColors
                                                                    .black
                                                                : ArgonColors
                                                                    .orangeApp),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 20.0),
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
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Text(
                                                          appointment.gender!,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                        Text(
                                                          '/${appointment.age!} ${appointment.ageType}',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                        if (appointment
                                                                .teleconsultationTypeId ==
                                                            1)
                                                          SizedBox(width: 5.0),
                                                        if (appointment
                                                                .teleconsultationTypeId ==
                                                            1)
                                                          Icon(
                                                            Icons.videocam,
                                                            color: Color(
                                                                0xFF333333),
                                                            size: 14,
                                                          ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Text(
                                                      '${appointment.service!} (${appointment.serviceType!})',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          appointmentList != null && appointmentList!.isNotEmpty
              ? Positioned(
                  top: searchFlag ? 90 : 10,
                  right: 5,
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_alt_outlined,
                      size: 30,
                      color: selectedFilters.isEmpty
                          ? ArgonColors.primary
                          : ArgonColors.green,
                    ),
                    onPressed: showFilterPopup,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
