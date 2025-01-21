import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outpatient_department/constants/utils.dart';

import '../../constants/Theme.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _profilePhoto;
  TextEditingController dobController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  String? selectedGender = "Male";
  final ImagePicker picker = ImagePicker();

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArgonColors.primary,
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.sp),
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
                  SizedBox(height: 15.sp),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add Patient',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Fill below details to add patient',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                                      radius: 50,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: _profilePhoto != null
                                          ? FileImage(_profilePhoto!)
                                          : null,
                                      child: _profilePhoto == null
                                          ? Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[600],
                                        size: 40.0,
                                      )
                                          : null, // Hide icon if photo is uploaded
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Upload Profile Photo',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 40.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Patient's Full Name",
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the patient's full name";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.sp),
                            TextFormField(
                              controller: dobController,
                              onTap: () async {
                                String selectedDate = await Utils.selectDate(context);
                                setState(() {
                                  dobController.text = selectedDate;
                                  if (selectedDate.isNotEmpty) {
                                    int age = Utils.calculateAge(selectedDate);
                                    ageController.text = age.toString();
                                  }
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Date Of Birth",
                                labelStyle: TextStyle(color: Colors.grey),
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
                            ),
                            SizedBox(height: 20.sp),

                            TextFormField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Age",
                                labelStyle: TextStyle(color: Colors.grey),
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
                            ),

                            SizedBox(height: 20.sp),
                            TextFormField(
                              controller: mobileController,
                              decoration: InputDecoration(
                                labelText: "Mobile Number",
                                labelStyle: TextStyle(color: Colors.grey),
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
                            SizedBox(height: 20.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Gender",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 8),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedGender == "Male"
                                        ? ArgonColors.primary
                                        : Colors.white,
                                    //padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = "Male";
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Male",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: selectedGender == "Male"
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedGender == "Female"
                                        ? ArgonColors.primary
                                        : Colors.white,
                                    //padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = "Female";
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Female",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: selectedGender == "Female"
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedGender == "Other"
                                        ? ArgonColors.primary
                                        : Colors.white,
                                    // padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = "Other";
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Other",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: selectedGender == "Other"
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.sp),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {

                         if (mobileController.text.isEmpty || mobileController.text.length != 10) {
                          Utils.showToastMessage('Please enter a valid mobile number');

                        }
                         else {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: Text('Patient information saved!'),
                             ),
                           );
                         }

                        }
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
                          '+ Add Patient',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
