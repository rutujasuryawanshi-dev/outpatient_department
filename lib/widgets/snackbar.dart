import 'package:flutter/material.dart';
import 'package:outpatient_department/constants/Theme.dart';

void showSnackBar(BuildContext context, int msgType, String msg) {
  Color backgroundColor;
  Icon? icon;

 /* if (msgType == 0) {
    backgroundColor = Colors.red;
    icon = Icon(Icons.phonelink_erase_rounded, color: Colors.white);
  } else*/ if (msgType == 1) {
    backgroundColor = Colors.green;
    icon = Icon(Icons.check_circle, color: Colors.white);
  } else if (msgType == 2) {
    backgroundColor = Colors.yellow;
    icon = Icon(Icons.error, color: Colors.white);
  } else if (msgType == 3) {
    backgroundColor = Colors.grey;
    icon = Icon(Icons.info, color: Colors.white);
  } else {
    backgroundColor = Colors.green;
    //icon = Icon(Icons.login, color: Colors.white);
  }

  // Show the SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          icon??Container(), // Icon for success or failure
          SizedBox(width: 10), // Space between icon and text
          Text(msg, style: TextStyle(color: Colors.white)),
        ],
      ),
      duration: Duration(seconds: 3), // Duration for the SnackBar
      backgroundColor: backgroundColor, // Success or failure color
      behavior: SnackBarBehavior.floating, // Floating behavior for the SnackBar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
    ),
  );
}
