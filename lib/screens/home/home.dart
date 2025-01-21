import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outpatient_department/screens/appointment/appointment_screen.dart';
import 'package:outpatient_department/screens/home/home_today_visit.dart';
import 'package:outpatient_department/widgets/drawer.dart';

import '../../Controller/clinic_controller.dart';
import '../../Controller/profile_controller.dart';
import '../../Model/Login/VerifyOTPResponse.dart';
import '../../Model/clinic/select_clinic_response.dart';
import '../../Model/profile/profile_response.dart';
import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../constants/utils.dart';
import 'HomeUpcommingVisitsScreen.dart';
import 'home_yesterday_visit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomepageState();
}

class _HomepageState extends State<HomeScreen> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var doctorname = '', clinicName = '';
  final box = GetStorage();
  SelectClinicResponse? selectClinicResponse;
  ProfileResponse? profileResponse;
  bool isABDMEnabled = true;

  @override
  void initState() {
    super.initState();

    VerifyOtpResponse? verifyOtpResponse;
    var loginresponse = box.read(Constant.loginResponse);
    var selectedClinic = box.read(Constant.selectedClinic);
    if (loginresponse != null && loginresponse != '') {
      verifyOtpResponse =
          VerifyOtpResponse.fromJson(json.decode(loginresponse));
      doctorname = verifyOtpResponse.sData?.iStaffDetails?.iStaffName ?? '';
      Constant.doctorname = doctorname;
      if (selectedClinic != null && selectedClinic != '') {
        var listAttractive = verifyOtpResponse.sData?.aClinics
            ?.where((element) => element.clinicId == selectedClinic.toString());
        listAttractive?.forEach((element) {
          clinicName = element.clinicName ??
              ''; // Print a specific property of each clinic
          Constant.clinicName = element.clinicName ??
              ''; // Print a specific property of each clinic
        });
      }
      setState(() {
        doctorname;
        clinicName;
      });
    }

    var clinicResponse = box.read(Constant.clinicTokenResponse);
    if (clinicResponse != null && clinicResponse != '') {
      selectClinicResponse = SelectClinicResponse.fromJson(json.decode(clinicResponse));
      _getRefreshToken(selectClinicResponse?.sData?.sAuthToken ?? '');
      getProfile();
    }

    _currentPageIndex = 1;
    _pageViewController = PageController(initialPage: 1);
    _tabController =
        TabController(length: 3, vsync: this); // Changed length to 3
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  Future<void> _getRefreshToken(String token) async {
    if (await Utils.isConnected()) {
      bool _isLoading = true;
      Utils.onLoading(context);

      ClinicController clinicController = ClinicController();
      try {


        final response = await clinicController
            .getRefreshToken(token ?? '');

        if (response != null) {
          SelectClinicResponse selectClinicResponse =
          SelectClinicResponse.fromJson(response.data);

          if (selectClinicResponse.sCode == 200) {
            Navigator.pop(context);
            _isLoading = false;
            String clinicResponse = jsonEncode(response.data);
            box.write(Constant.clinicTokenResponse, clinicResponse);
          } else {}
        } else {
          print(response);
        }
      } catch (e) {
        print(e);
      } finally {
        if (_isLoading) {
          Navigator.pop(context);
        }
        setState(() {});
      }
    } else {
      Utils.showToastMessage(Constant.internetConMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ArgonDrawer(currentPage: Constant.home),
      appBar: AppBar(
        backgroundColor: ArgonColors.primary,
        //automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 2.0,
        title: Row(
          children: [
           /* SizedBox(width: 8.0),*/
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. ${doctorname}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  clinicName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
              onPressed: () {
               // _scaffoldKey.currentState?.openDrawer();
              },
            ),
            Spacer(),
            Wrap(children: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    Constant.searchFlag = !Constant.searchFlag;
                  });
                },
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: PopupMenuThemeData(
                    color: Colors.white, // White background for the popup menu
                    textStyle: TextStyle(color: Colors.black), // Text color
                  ),
                ),
                child: Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Image.asset(
                        'assets/img/add_user.png',
                        height: 19,
                        width: 19,
                      ),
                      onPressed: () {
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(70, 70, 10, 0),
                          items: <PopupMenuEntry>[
                            if (isABDMEnabled)
                              PopupMenuItem(
                                value: 'Book with ABHA',
                                child: Row(
                                  children: [
                                    Icon(Icons.health_and_safety,
                                        color: ArgonColors.primary),
                                    SizedBox(width: 8),
                                    Text('Book with ABHA'),
                                  ],
                                ),
                              ),
                            PopupMenuItem(
                              value: 'Book Now',
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month_outlined,
                                      color: ArgonColors.primary),
                                  SizedBox(width: 8),
                                  Text('Book Now'),
                                ],
                              ),
                            ),
                          ],
                        ).then((value) {
                          if (value == 'Book With ABHA') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppointmentScreen(appointments: null)),
                            );
                            // Handle Book with ABHA logic
                            print('Book with ABHA selected');
                          } else if (value == 'Book Now') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppointmentScreen(appointments: null)),
                            );
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ])
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            children: <Widget>[
              HomeYesterdayVisitScreen(),
              HomeTodayVisitScreen(),
              HomeUpcommingVisitsScreen(),
            ],
          ),
          PageIndicator(
            tabController: _tabController,
            currentPageIndex: _currentPageIndex,
            onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          ),
        ],
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // Reusable AppBar
  AppBar buildCommonAppBar(String title) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }

  Future<void> getProfile() async {
    box.write(Constant.profileResponse, '');
    if (await Utils.isConnected()) {
      ProfileController profileController = ProfileController();
      try {
        final response = await profileController
            .getProfileDetails(selectClinicResponse?.sData?.sAuthToken);
        if (response != null) {
          profileResponse = ProfileResponse.fromJson(response.data);
          if (profileResponse?.sCode == 200) {
            setState(() {
              profileResponse;
              String loginResponse = jsonEncode(response.data);
              box.write(Constant.profileResponse, loginResponse);
            });
          } else {}
        } else {}
      } catch (e) {
        print(e);
      } finally {}
    } else {}
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /*IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
            ),
          ),
          TabPageSelector(
            controller: tabController,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 1) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: const Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
            ),
          ),

           */
        ],
      ),
    );
  }
}
