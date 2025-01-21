import 'package:flutter/material.dart';
import 'package:outpatient_department/constants/Theme.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Appointment Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          padding: EdgeInsets.all(2.0),
          margin: EdgeInsets.only(left: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
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
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sam James Bahadur ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '(M/53 Yrs)',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'PU-B92-AAA4051',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Consultation (General Practice)',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns content to the start
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month_outlined,
                            color: ArgonColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Tuesday, 17th December, 2024 \nat 02:00 PM - 02:15 PM',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.person, color: ArgonColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Priyanka D (PRD)',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: ArgonColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Lifewave Health\n601/A, East Court, Next to Phoenix Market \nCity, Off. Nagar Rd, Viman Nagar, Pune,\n Maharashtra 411014, Pune, \nIndia, Pincode: 411014',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone, color: ArgonColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Call 9589874858 for help',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 8),
              Text(
                'Bill Details (as of 17-12-2024)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ArgonColors.primary,
                ),
              ),
              SizedBox(height: 8),
              Card(
                color: Colors.white,
                shadowColor: Colors.grey.shade200,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.medical_services,
                              color: ArgonColors.primary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Consultation (General Practice) with Priyanka D in clinic',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Divider(),
                      _buildBillRow('Total Amount', 'Rs. 200', Colors.black),
                      SizedBox(height: 8),
                      _buildBillRow('Discounts', 'Rs. 0', Colors.black),
                      SizedBox(height: 8),
                      Divider(thickness: 1.2),
                      _buildBillRow(
                        'Net Amount',
                        'Rs. 200.00',
                        Colors.black,
                        isBold: true,
                      ),
                      SizedBox(height: 8),
                      _buildBillRow(
                        'Pending Amount',
                        'Rs. 200.00',
                        Colors.red,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Confirm Appointment Action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ArgonColors.primary,
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    label: Text(
                      'Confirm Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Reset Action
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.orange),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    label: Text(
                      'Reset',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, Color color,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
