import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Model/Appointment/GetAppointments.dart';
import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../constants/utils.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/drawer.dart';
import '../patient/add_patient_screen.dart';

class Patient {
  final String patientNo;
  final String name;
  final String gender;
  final int age;

  Patient(
      {required this.patientNo,
        required this.name,
        required this.gender,
        required this.age});
}

class AppointmentScreen extends StatefulWidget {

  final Appointments? appointments; // Another example argument

  const AppointmentScreen({
    Key? key,
    required this.appointments,
  }) : super(key: key);
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool isABDMEnabled = true;
  int selectedIndex = 0;
  TextEditingController discountController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  String selectedPaymentMode = 'Cash'; // Default value
  double totalAmount = 0.00;
  double netAmount = 0.00;
  double pendingAmount = 0.00;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNewPatient=false;

  String? selectedTimeSlot;
  String? selectedPeriod = "Morning";
  String? selectedConsultant = "WalkinConsultation";

  final List<String> paymentModes = ['Cash','Card','UPI'];
  final _formKey = GlobalKey<FormState>();
  File? _profilePhoto;
  TextEditingController patientNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  String? selectedGender = "Male";
  final ImagePicker picker = ImagePicker();


  DateTime currentDate = DateTime.now();
  Patient? selectedPatient;
  bool isLoading = false;
  List<Patient> patients = [
    Patient(patientNo: 'P001', name: 'John Doe', gender: 'Male', age: 30),
    Patient(patientNo: 'P002', name: 'Jane Smith', gender: 'Female', age: 25),
    Patient(
        patientNo: 'P003', name: 'Michael Johnson', gender: 'Male', age: 45),
  ];

  List<Patient> originalList = [];

  void getPreviousMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
    });
  }

  void getNextMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    });
  }

  String getCurrentMonth() {
    return '${currentDate.month < 10 ? '0${currentDate.month}' : currentDate.month}';
  }

  String getCurrentYear() {
    return '${currentDate.year}';
  }

  String getMonthName() {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[currentDate.month - 1];
  }


  List<String> morningSlots = [
    "7:00 AM",
    "7:30 AM",
    "8:00 AM",
    "8:30 AM",
    "9:00 AM",
    "9:30 AM",
    "10:00 AM"
  ];

  List<String> afternoonSlots = [
    "12:00 PM",
    "12:30 PM",
    "1:00 PM",
    "1:30 PM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM"
  ];

  List<String> nightSlots = [
    "5:00 PM",
    "5:30 PM",
    "6:00 PM",
    "6:30 PM",
    "7:00 PM",
    "7:30 PM",
    "8:00 PM",
  ];

  void selectPeriod(String period) {
    setState(() {
      selectedPeriod = period;
      selectedTimeSlot = null;
    });
  }

  void selectTimeSlot(String slot) {
    setState(() {
      selectedTimeSlot = slot;
    });
  }

  List<String> getTimeSlotsForSelectedPeriod() {
    if (selectedPeriod == "Morning") {
      return morningSlots;
    } else if (selectedPeriod == "Afternoon") {
      return afternoonSlots;
    } else {
      return nightSlots;
    }
  }

  int getNumberOfDaysInMonth() {
    int nextMonth = currentDate.month == 12 ? 1 : currentDate.month + 1;
    int nextMonthYear =
    currentDate.month == 12 ? currentDate.year + 1 : currentDate.year;
    DateTime nextMonthDate = DateTime(nextMonthYear, nextMonth, 1);
    return nextMonthDate.subtract(Duration(days: 1)).day;
  }

  int getFirstWeekdayOfMonth() {
    return DateTime(currentDate.year, currentDate.month, 1).weekday;
  }

  void _performSearch(String query) async {

    setState(() {
      isLoading = true;
      patients = originalList;
    });

    await Future.delayed(Duration(seconds: 1));
    final filteredPatients = patients.where((patient) {
      return patient.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      patients = filteredPatients;
      isLoading = false;
    });
  }

  void showAcceptPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ArgonColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Accept Payment',
                  style: TextStyle(
                    fontSize: 18,
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
                      child: Text('Collect',
                          style: TextStyle(color: ArgonColors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ArgonColors.primary,
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


  void clearFields() {
    setState(() {
      _profilePhoto = null;
      patientNameController.clear();
      dobController.clear();
      mobileController.clear();
      ageController.clear();
      selectedGender = 'Male';
    });
  }
  void initState() {
    super.initState();

    if (widget.appointments != null ) {
      Patient patient=Patient(patientNo: 'P00001' ,
        name: widget.appointments!.name ?? '',
        gender: widget.appointments!.gender ?? '',
        age: (widget.appointments!.age ?? 0).toInt(),
      );
      selectedPatient=patient;
    }
  }

  Future<void> _showImagePickerDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }
  List gender=["Male","Female","Other"];

  String? select;
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value){
            setState(() {
              print(value);
              select=value;
            });
          },
        ),
        Text(title, style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12
        ),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _scaffoldKey,
      backgroundColor: ArgonColors.white,
      endDrawer:widget.appointments == null?
      Drawer(
        child: Container(
          color: ArgonColors.white, // Background color of the drawer
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // Header Section
                Container(
                  color: ArgonColors.primary, // Background color for the header
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                       */
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Add Patient',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Fill below details to add patient',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0),
                // Form Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: _showImagePickerDialog,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: _profilePhoto != null
                                      ? FileImage(_profilePhoto!)
                                      : null,
                                  child: _profilePhoto == null
                                      ? Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[600],
                                    size: 30.0,
                                  )
                                      : null, // Hide icon if photo is uploaded
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Upload Profile Photo',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: patientNameController,
                          decoration: InputDecoration(
                            labelText: "Patient's Full Name",
                            labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 12),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          style: TextStyle(fontSize: 12),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the patient's full name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Row(children: [
                          Expanded(child: TextFormField(
                            controller: dobController,
                            onTap: () async {
                              String selectedDate =
                              await Utils.selectDate(context);
                              setState(() {
                                dobController.text = selectedDate;
                                if (selectedDate.isNotEmpty) {
                                  int age = Utils.calculateAge(selectedDate);
                                  ageController.text = age.toString();
                                }
                              });
                            },
                            readOnly: true,
                            style: TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              labelText: "Date Of Birth",
                              labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                if (ageController.text.isEmpty) {
                                  return "Please enter the date of birth";
                                }
                              }
                              return null;
                            },
                          ),),
                          SizedBox(width: 30),
                          Expanded(child: TextFormField(
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              labelText: "Age",
                              labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  dobController.clear();
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                if (dobController.text.isEmpty) {
                                  return "Please enter the age";
                                }
                              }
                              return null;
                            },
                          ),),
                        ],),

                        /*SizedBox(height: 10),*/

                        SizedBox(height: 10),
                        TextFormField(
                          controller: mobileController,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            labelText: "Mobile Number",
                            labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 12),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            counterText: "",
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the mobile number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Gender",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            addRadioButton(0, 'Male'),
                            addRadioButton(1, 'Female'),
                            addRadioButton(2, 'Others'),
                          ],
                        ),
                        /*Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioListTile<String>(
                              title: Text(
                                "Male",
                                style: TextStyle(fontSize: 12),
                              ),
                              value: "Male",
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text(
                                "Female",
                                style: TextStyle(fontSize: 12),
                              ),
                              value: "Female",
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text(
                                "Other",
                                style: TextStyle(fontSize: 12),
                              ),
                              value: "Other",
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                          ],
                        ),*/

                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (mobileController.text.isEmpty ||
                                    mobileController.text.length != 10) {
                                  Utils.showToastMessage(
                                      'Please enter a valid mobile number');
                                } else {


                                  setState(() {
                                    isNewPatient=true;
                                    Patient patient=Patient(patientNo: 'P0001',
                                        name:patientNameController.text ?? '',
                                        gender: selectedGender ?? '',
                                        age: int.tryParse(ageController.text)?? 0);

                                    selectedPatient=patient;
                                  });

                                  Navigator.pop(context);
                                  Utils.showToastMessage(
                                      'Patient information saved!');
                                  //clearFields();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ArgonColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 10.0),
                            ),
                            child: Center(
                              child: Text(
                                '+ Add Patient',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          :null,
      drawer: ArgonDrawer(currentPage: ''),
      appBar: CustomAppBar(
        doctorName: Constant.doctorname,
        clinicName: Constant.clinicName,
        scaffoldKey: _scaffoldKey,
        isABDMEnabled: isABDMEnabled,
        onRefresh: (bool value){
          /*setState(() {
            searchFlag = !searchFlag;
          });*/
        },
      ),
      /*appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: ArgonColors.white,
        centerTitle: true,
        title: Text(
          "Get Schedule",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[Container()],   // this will hide endDrawer hamburger icon

        leading: Container(
          padding: EdgeInsets.all(2.0),
          margin: EdgeInsets.only(left: 16.0),
          decoration: BoxDecoration(
            color: ArgonColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ArgonColors.black.withOpacity(0.2),
                blurRadius: 4.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 20.0,
            color: ArgonColors.black,
          ),
        ),
      ),*/
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedPatient == null)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(

                          style: TextStyle(fontSize: 11),
                          controller: _searchController,

                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 12),
                            labelText: 'Search Patient Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),

                              ),
                              borderSide: BorderSide(color: ArgonColors.primary, width: 1.0),

                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              borderSide: BorderSide(color: ArgonColors.primary, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              borderSide: BorderSide(color: ArgonColors.primary, width: 1.0),
                            ),

                          ),
                          onChanged: (value) {
                            setState(() {
                              originalList = patients;
                            });
                            if (value.isNotEmpty) {
                              _performSearch(value);
                            } else {
                              setState(() {
                                patients.clear();
                              });
                            }
                          },
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: ArgonColors.primary,

                          borderRadius: BorderRadius.only(

                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.search, color: ArgonColors.white),
                          onPressed: () {
                            setState(() {
                              originalList = patients;
                            });
                            if (_searchController.text.isNotEmpty) {
                              _performSearch(_searchController.text);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                    Text("Please enter a name to search")),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 80.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: ArgonColors.primary,
                          //borderRadius: BorderRadius.zero,
                          borderRadius: BorderRadius.circular(8),

                        ),
                        child: TextButton(
                          onPressed: () {
                            /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddPatientScreen()),
                            );

                             */
                            _scaffoldKey.currentState?.openEndDrawer();

                          },
                          child: Text(
                            '+ Add New',
                            style: TextStyle(
                              color: ArgonColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                //SizedBox(height: 10),
                if (isLoading)
                  Center(
                    child: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                      ),
                    ),
                  ),
                if (_searchController.text != "")
                  Container(
                    height: 200,
                    child: (patients.isNotEmpty)
                        ? ListView.builder(
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPatient = patients[index];
                                _searchController.text = "";
                              });
                            },
                            child: Text(
                              '${patients[index].name} (${patients[index].patientNo})',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    )
                        : Center(child: Text('No record found')),
                  ),
                if (selectedPatient != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.person,
                            size: 50,
                            color: ArgonColors.black,
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${selectedPatient!.name} (${selectedPatient!.patientNo})',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Age: ${selectedPatient!.age}',
                              style: TextStyle(
                                  fontSize: 10, color: ArgonColors.black),
                            ),
                            Text(
                              'Gender: ${selectedPatient!.gender}',
                              style: TextStyle(
                                  fontSize: 10, color: ArgonColors.black),
                            ),
                          ],
                        ),
                      ),
                      if(widget.appointments == null )
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                //_scaffoldKey.currentState?.openEndDrawer();
                                setState(() {
                                  selectedPatient = null;
                                  clearFields();
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                size: 20,
                                color: ArgonColors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState?.openEndDrawer();
                                /* setState(() {
                           // selectedPatient = null;
                          });*/
                              },
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: ArgonColors.black,
                              ),
                            ),
                          ],
                        ),

                    ],
                  ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${getMonthName()} ${getCurrentYear()}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ArgonColors.black,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: getPreviousMonth,
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: getNextMonth,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(getNumberOfDaysInMonth(), (index) {
                  DateTime day =
                  DateTime(currentDate.year, currentDate.month, index + 1);
                  String dayOfWeek = [
                    "Mon",
                    "Tue",
                    "Wed",
                    "Thu",
                    "Fri",
                    "Sat",
                    "Sun"
                  ][day.weekday - 1];

                  bool isSelected = index == selectedIndex;

                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        width: 50,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ArgonColors.secondary_color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dayOfWeek,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: ArgonColors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ArgonColors.primary
                                    : Colors.lightBlue[50],
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${day.day}",
                                style: TextStyle(
                                  color: isSelected
                                      ? ArgonColors.white
                                      : ArgonColors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Available Slots",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ArgonColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPeriod == "Morning"
                        ? ArgonColors.primary
                        : ArgonColors.white,
                    //padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () => selectPeriod("Morning"),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sunny_snowing,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Morning",
                        style: TextStyle(
                          fontSize: 12,
                          color: selectedPeriod == "Morning"
                              ? ArgonColors.white
                              : ArgonColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPeriod == "Afternoon"
                        ? ArgonColors.primary
                        : ArgonColors.white,
                    //padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () => selectPeriod("Afternoon"),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sunny,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Afternoon",
                        style: TextStyle(
                          fontSize: 12,
                          color: selectedPeriod == "Afternoon"
                              ? ArgonColors.white
                              : ArgonColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPeriod == "Night"
                        ? ArgonColors.primary
                        : ArgonColors.white,
                    // padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () => selectPeriod("Night"),
                  child: Row(
                    children: [
                      Icon(
                        Icons.mode_night,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Night",
                        style: TextStyle(
                          fontSize: 12,
                          color: selectedPeriod == "Night"
                              ? ArgonColors.white
                              : ArgonColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 1,
              color: ArgonColors.border,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Wrap(
                spacing: 10,
                runSpacing: 8,
                children: List.generate(
                  (getTimeSlotsForSelectedPeriod().length / 4).ceil(),
                      (rowIndex) {
                    int startIndex = rowIndex * 4;
                    int endIndex = startIndex + 4;
                    List<String> rowTimeSlots =
                    getTimeSlotsForSelectedPeriod().sublist(
                      startIndex,
                      endIndex > getTimeSlotsForSelectedPeriod().length
                          ? getTimeSlotsForSelectedPeriod().length
                          : endIndex,
                    );
                    return Row(
                      children: List.generate(
                        rowTimeSlots.length,
                            (index) {
                          String timeSlot = rowTimeSlots[index];
                          return Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Container(
                              width: 80,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedTimeSlot == timeSlot
                                      ? ArgonColors.primary
                                      : ArgonColors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () => selectTimeSlot(timeSlot),
                                child: Text(
                                  timeSlot,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: selectedTimeSlot == timeSlot
                                        ? ArgonColors.white
                                        : ArgonColors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Consultant Fees",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ArgonColors.black,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildConsultationButton(
                    selected: selectedConsultant == "WalkinConsultation",
                    icon: Icons.local_hospital,
                    price: "₹10.00",
                    label: "Walkin\nConsultation",
                    onPressed: () {
                      setState(() {
                        selectedConsultant = "WalkinConsultation";
                      });
                    },
                  ),
                  SizedBox(width: 20),
                  _buildConsultationButton(
                    selected: selectedConsultant == "Teleconsultation",
                    icon: Icons.call,
                    price: "\n₹20.00",
                    label: "Teleconsultation",
                    onPressed: () {
                      setState(() {
                        selectedConsultant = "Teleconsultation";
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*
                  Container(
                    width: 160.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: TextButton(
                      onPressed: () => showAcceptPaymentDialog(context),
                      child: Text(
                        'Take Payment',
                        style:
                        TextStyle(color: ArgonColors.white, fontSize: 16),
                      ),
                    ),
                  ),

                   */
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      minimumSize: Size(160.0, 40.0), // Width and height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0), // Rounded corners
                      ),
                    ),
                    onPressed: () => showAcceptPaymentDialog(context),
                    child: Text(
                      'Take Payment',
                      style: TextStyle(
                        fontSize: 14,
                        color: ArgonColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pop();
                    showAppointmentSuccessDialog(context);
                  });

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ArgonColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 24.0),
                ),
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: ArgonColors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showAppointmentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(height: 10),
              Text(
                "Success",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ArgonColors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Your appointment has been booked successfully!",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: ArgonColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConsultationButton({
    required bool selected,
    required IconData icon,
    required String price,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? ArgonColors.primary : ArgonColors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        width: 110,
        //height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: ArgonColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ArgonColors.black.withOpacity(0.2),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: ArgonColors.black,
                size: 15,
              ),
            ),
            SizedBox(height: 10),
            Text(
              price,
              style: TextStyle(
                fontSize: 12,
                color: selected ? ArgonColors.white : ArgonColors.black,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: selected ? ArgonColors.white : ArgonColors.border,
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
