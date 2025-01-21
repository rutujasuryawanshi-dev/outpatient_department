import 'package:flutter/material.dart';
import 'package:outpatient_department/constants/Constant.dart';
import 'package:outpatient_department/constants/Theme.dart';
import 'package:outpatient_department/screens/appointment/appointment_screen.dart';
import 'package:outpatient_department/screens/home/home.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(bool) onRefresh;
  final String doctorName;
  final String clinicName;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isABDMEnabled;


  CustomAppBar({
    required this.onRefresh,
    required this.doctorName,
    required this.clinicName,
    required this.scaffoldKey,
    required this.isABDMEnabled,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  //bool searchFlag = false; // local state for the search flag

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ArgonColors.primary,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 2.0,
      title: Row(
        children: [
          SizedBox(width: 8.0),
          GestureDetector(
            onTap: () {
              // You can handle navigation here if needed
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. ${widget.doctorName}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  widget.clinicName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              // You can add functionality to open drawer or something else
            },
          ),
          Spacer(),
          Wrap(
            children: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.onRefresh(true);
                },
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: PopupMenuThemeData(
                    color: Colors.white,
                    textStyle: TextStyle(color: Colors.black),
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
                            if (widget.isABDMEnabled)
                              PopupMenuItem(
                                value: 'Book with ABHA',
                                child: Row(
                                  children: [
                                    Icon(Icons.health_and_safety, color: ArgonColors.primary),
                                    SizedBox(width: 8),
                                    Text('Book with ABHA'),
                                  ],
                                ),
                              ),
                            PopupMenuItem(
                              value: 'Book Now',
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month_outlined, color: ArgonColors.primary),
                                  SizedBox(width: 8),
                                  Text('Book Now'),
                                ],
                              ),
                            ),
                          ],
                        ).then((value) {
                          if (value == 'Book With ABHA' || value == 'Book Now') {
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
            ],
          ),
        ],
      ),
    );
  }
}
