import 'package:flutter/material.dart';

import '../../constants/Constant.dart';
import '../../constants/Theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/drawer.dart';

class BillingDetailScreen extends StatelessWidget {
   BillingDetailScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   bool isABDMEnabled = true;
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
          /*setState(() {
            searchFlag = !searchFlag;
          });*/
        },
      ),
      backgroundColor: ArgonColors.white,
      drawer: ArgonDrawer(currentPage: Constant.billing),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0), // Outer padding
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300), // Border around the screen
            borderRadius: BorderRadius.circular(12),
            color: Colors.white, // Background color of the entire screen content
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title - Lifewave Health
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Lifewave Health',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),

              // Subtitle - Bill Details
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Bill Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),

              // Bill Details - Static data (Two items in a row)
              _buildDetailRow("Bill Number : ", 'BILL123456', "Visit No : ", 'VISIT78910'),
              _buildDetailRow("Billed To : ", 'John Doe', "Bill Date : ", '2024-12-17'),
              _buildDetailRow("Visit Date : ", '2024-12-17', "Pending Amount : ", "₹20.00"),
              _buildDetailRow("Visit Time : ", 'Morning - 7:30', "", ""),

              // Divider Line
              Divider(thickness: 1, color: Colors.grey.shade300),
              SizedBox(height: 20),

              // Subtitle - Bill Items
              Text(
                "Bill Items",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: 12),

              Text(
                "Consultation",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              // Divider Line - Blue
              Divider(thickness: 2, color: Colors.blue.shade700),
              SizedBox(height: 20),

              // Payment Details Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "1 Consultation (General Practice) with Priyanka D \non 16-12-2024 at 6:30 PM in clinic",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "₹200",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildBillingDetailItem("Total", "₹200.00"),
              _buildBillingDetailItem("Discount", "₹00.00"),
              _buildBillingDetailItem("Taxes", "₹00.00"),
              Divider(thickness: 1, color: Colors.grey.shade300),
              _buildBillingDetailItem("Net Amount", "₹200.00"),
              Divider(thickness: 1, color: Colors.grey.shade300),
              _buildBillingDetailItem("Paid Amount", "₹00.00"),
              _buildBillingDetailItem("Pending Amount", "₹200.00"),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create two items in one row
  Widget _buildDetailRow(String title1, String value1, String title2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          _buildDetailItem(title1, value1),
          SizedBox(width: 20), // Add space between the two items
          _buildDetailItem(title2, value2),
        ],
      ),
    );
  }

  // Helper method to create a single billing detail item
  Widget _buildDetailItem(String title, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title+' ',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create a billing breakdown item
  Widget _buildBillingDetailItem(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 10),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 10, color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }
}
