

import '../Model/Appointment/GetAppointments.dart';
import '../Model/profile/profile_response.dart';

class Constant {

  static final String isAlreadyLogin = 'isAlreadyLogin';
  static final String nA = 'N/A';
  static final String userName = 'userName';
  static final String name = 'name';
  static final String password = 'password';
  static final String internetConMsg = 'Please check your internet connection!';
  static final String loginResponse = 'loginResponse';
  static final String clinicTokenResponse = 'clinicTokenResponse';
  static final String selectedClinic = 'selectedClinic';
  static final String selectedStaff = 'selectedStaff';

  //drawer menu
  static final String home = 'Home';
  static final String profile = 'Profile';
  static final String patient = 'Patients';
  static final String billing = 'Bills';
  static final String appointments = 'Appointments';
  static final String settings = 'Settings';
  static final String performance = 'Performance';
  static final String help = 'Self-help';

  static final String isPinSet = 'isPinSet';
  static final String PIN = 'PIN';
  static final String isBiometric = 'isBiometric';

  static bool searchFlag=false;
  static final String staff = 'Select Staff';
  static final String clinic = 'Select Clinic';

  static final String profileResponse = 'ProfileResponse';
  static String clinicName = '';
  static String doctorname = '';

  static bool todayAppt = false;
  static bool yestAppt = false;
  static bool tommAppt = false;




  static final List<Appointments> samplePatientData = [
    Appointments(
      scheduleId: 1,
      appointmentId: 101,
      date: "2025-01-18",
      time: "10:00 AM",
      name: "Arjun Patel",
      gender: "Male",
      ageString: "30",
      ageType: "Years",
      age: 30,
      mobile: "9876543210",
      serviceType: "General Checkup",
      service: "Consultation",
      status: 1,
      doctorAlias: "Dr. Sharma",
      billId: 201,
      teleconsultationTypeId: 301,
      pendingAmount: 50,
      isServiceCompleted: 0,
      consultationId: 401,
    ),
    Appointments(
      scheduleId: 2,
      appointmentId: 102,
      date: "2025-01-19",
      time: "02:00 PM",
      name: "Priya Gupta",
      gender: "Female",
      ageString: "25",
      ageType: "Years",
      age: 25,
      mobile: "9123456789",
      serviceType: "Dental Checkup",
      service: "Consultation",
      status: 2,
      doctorAlias: "Dr. Kapoor",
      billId: 202,
      teleconsultationTypeId: 302,
      pendingAmount: 0,
      isServiceCompleted: 1,
      consultationId: 402,
    ),
    Appointments(
      scheduleId: 3,
      appointmentId: 103,
      date: "2025-01-20",
      time: "11:00 AM",
      name: "Suresh Reddy",
      gender: "Male",
      ageString: "45",
      ageType: "Years",
      age: 45,
      mobile: "9898989898",
      serviceType: "Heart Checkup",
      service: "Consultation",
      status: 1,
      doctorAlias: "Dr. Rao",
      billId: 203,
      teleconsultationTypeId: 303,
      pendingAmount: 100,
      isServiceCompleted: 0,
      consultationId: 403,
    ),
    Appointments(
      scheduleId: 4,
      appointmentId: 104,
      date: "2025-01-20",
      time: "11:00 AM",
      name: "Rohit Chavan",
      gender: "Male",
      ageString: "30",
      ageType: "Years",
      age: 30,
      mobile: "9702713057",
      serviceType: "Heart Checkup",
      service: "Consultation",
      status: 1,
      doctorAlias: "Dr. Rao",
      billId: 203,
      teleconsultationTypeId: 303,
      pendingAmount: 100,
      isServiceCompleted: 0,
      consultationId: 403,
    ),
  ];
}