import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:outpatient_department/screens/appointment/consultation_manual.dart';
import 'package:outpatient_department/screens/appointment/consultation_photo.dart';
import 'package:outpatient_department/screens/appointment/consultation_voice.dart';
import 'package:outpatient_department/screens/profile/update_password.dart';
import 'package:outpatient_department/widgets/drawer.dart';

import '../../Model/Appointment/GetAppointments.dart';
import '../../Model/Login/VerifyOTPResponse.dart';
import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/navbar.dart';
import '../../widgets/searchbar.dart';
import '../clinic/SelectStaffAttachedToClinic.dart';
import '../clinic/clinic_list.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isAutoSyncEnabled = false;
  bool _isBiometricEnabled = false;
  final box = GetStorage();
  String? _selectedOption;
  // final List<bool> _selectedOptions = List.generate(6, (_) => false);
  List<bool> _selectedOptions = [false, false, false, false, false, false]; // Initialize with 6 elements
  void _showAppSettingsDialog(BuildContext context, List<bool> selectedOptions, Function(List<bool>) onUpdate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                    // Title
                    Text(
                      'App Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Checkbox List with Green Color and Different Format
                    CheckboxListTile(
                      value: selectedOptions[0],
                      title: Text('Track Waiting Time'),
                      activeColor: Colors.green, // Green color for the checkbox
                      onChanged: (bool? value) {
                        setState(() {
                          selectedOptions[0] = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, // Place the checkbox to the left
                    ),
                    CheckboxListTile(
                      value: selectedOptions[1],
                      title: Text('Allow Back-dated Appointments'),
                      activeColor: Colors.green, // Green color for the checkbox
                      onChanged: (bool? value) {
                        setState(() {
                          selectedOptions[1] = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, // Place the checkbox to the left
                    ),
                    CheckboxListTile(
                      value: selectedOptions[2],
                      title: Text('Allow Receptionist To Print Notes'),
                      activeColor: Colors.green, // Green color for the checkbox
                      onChanged: (bool? value) {
                        setState(() {
                          selectedOptions[2] = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, // Place the checkbox to the left
                    ),
                    CheckboxListTile(
                      value: selectedOptions[3],
                      title: Text('Allow Receptionist To Attach Medical Records'),
                      activeColor: Colors.green, // Green color for the checkbox
                      onChanged: (bool? value) {
                        setState(() {
                          selectedOptions[3] = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, // Place the checkbox to the left
                    ),
                    CheckboxListTile(
                      value: selectedOptions[4],
                      title: Text('Enable/Disable WhatsApp Messages'),
                      activeColor: Colors.green, // Green color for the checkbox
                      onChanged: (bool? value) {
                        setState(() {
                          selectedOptions[4] = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, // Place the checkbox to the left
                    ),
                    CheckboxListTile(
                      value: selectedOptions[5],
                      title: Text('Enable/Disable Email Messages'),
                      activeColor: Colors.green, // Green color for the checkbox
                      onChanged: (bool? value) {
                        setState(() {
                          selectedOptions[5] = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, // Place the checkbox to the left
                    ),

                    // Submit Button
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          onUpdate(selectedOptions); // Update the options in the parent
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ArgonColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 15),
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
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isABDMEnabled = true;
  void _showConsultationOptions(BuildContext context) {
    final ImagePicker _picker = ImagePicker();

    Future<void> _takePhoto() async {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        print("Photo taken: ${photo.path}");
      }
    }

    // Check if the selected option is already saved in GetStorage
    final box = GetStorage();
    String? selectedOption = box.read('selectedOption');

    // If no option is selected, set a default one
    if (selectedOption == null) {
      selectedOption = "None";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Consultation Type",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.blue,
                  ),
                  title: Text(
                    "Take Photo",
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: selectedOption == "Take Photo"
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () async {
                    // Save the selected option to GetStorage
                    box.write('selectedOption', "Take Photo");

                    // Close the dialog
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.green,
                  ),
                  title: Text(
                    "Use AI",
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: selectedOption == "Use AI"
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    // Save the selected option to GetStorage
                    box.write('selectedOption', "Use AI");

                    // Close the dialog
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.edit_note_outlined,
                    color: Colors.orange,
                  ),
                  title: Text(
                    "Write Clinical Notes",
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: selectedOption == "Write Clinical Notes"
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    // Save the selected option to GetStorage
                    box.write('selectedOption', "Write Clinical Notes");

                    // Close the dialog
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ArgonColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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

  /* final LocalAuthentication _localAuth = LocalAuthentication();
  // Check if biometric authentication is available
  Future<void> _checkBiometricStatus() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      // Check for biometrics (Fingerprint/Face ID)
      final isBiometricAvailable = await _localAuth.isDeviceSupported();
      setState(() {
        _isBiometricEnabled = isBiometricAvailable;
      });
    } else {
      setState(() {
        _isBiometricEnabled = false;
      });
    }
  }
*/
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating...';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate using your fingerprint or face.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true, // Biometric only (fingerprint or face)
        ),
      );
    } on PlatformException catch (e) {
      _handleError(e);
      return;
    }
    if (mounted) {
      setState(() {
        _isAuthenticating = false;
        _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      });

      if (authenticated) {
        setState(() {
          box.write(Constant.isBiometric, true);
          _isBiometricEnabled = true;
        });
      }
    }
  }

  void _handleError(PlatformException e) {
    print('Error: $e');
    setState(() {
      _isAuthenticating = false;
      _authorized = 'Error: ${e.message}';
    });
  }

  TextEditingController _searchPatientController = TextEditingController();
  Appointments? selectedPatient;
  List<Appointments> filteredPatientData = [];
  bool searchFlag = false;
  @override
  void initState() {
    super.initState();

    _isBiometricEnabled = (box.read(Constant.isBiometric) ?? false);

    filteredPatientData = Constant.samplePatientData;
    _searchPatientController.addListener(_filterAppointments);
    // _checkBiometricStatus();
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
      backgroundColor: Colors.white,
      drawer: ArgonDrawer(currentPage: Constant.settings),
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
         // SizedBox(height: 20),
          Expanded(
            child: Container(
              /*decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),*/
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.notifications_outlined, color: Colors.black),
                        const SizedBox(width: 16),
                        Text(
                          'Notifications',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black54),
                        ),
                        const Spacer(),
                        Container(
                          width: 40,
                          child: SwitchListTile(
                            value: _isAutoSyncEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isAutoSyncEnabled = value;
                              });
                            },
                            activeColor:  ArgonColors.primary,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.fingerprint, color: Colors.black),
                        const SizedBox(width: 16),
                        Text(
                          'Biometric Login',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black54),
                        ),
                        const Spacer(),
                        Container(
                          width: 40,
                          child: SwitchListTile(
                            value: _isBiometricEnabled,
                            onChanged: (value) {
                              if(value){
                                _authenticateWithBiometrics();
                              }
                              else {
                                setState(() {
                                  box.write(Constant.isBiometric, value);
                                  _isBiometricEnabled = false;
                                });
                              }

                            },
                            activeColor: ArgonColors.primary,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /*SettingsOption(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      // Add logic for Notifications if needed
                    },
                  ),*/

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 16),
                    child: SettingsOption(
                      icon: Icons.lock_open_outlined,
                      title: 'Update Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpdatePasswordScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 16
                    ),
                    child: SettingsOption(
                      icon: Icons.local_hospital_rounded,
                      title: 'Switch Clinic',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectStaffAttachedToClinicScreen()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 16),
                    child: SettingsOption(
                      icon: Icons.person_pin_outlined,
                      title: 'Consultation Type',
                      onTap: () {
                        _showConsultationOptions(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 16),
                    child: SettingsOption(
                      icon: Icons.app_settings_alt,
                      title: 'App Settings',
                      onTap: () {
                        _showAppSettingsDialog(context, _selectedOptions, (updatedOptions) {
                          setState(() {
                            _selectedOptions = updatedOptions;
                          });
                        });

                      },
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

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:
      //Padding(
      // padding: const EdgeInsets.symmetric(
      //    vertical: 12, horizontal: 16),
      //    child:

      Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
          /* SwitchListTile(
              value: true,
              onChanged: (value) {

              },
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey[300],
            ),*/
        ],
      ),
      // ),
    );
  }

}
