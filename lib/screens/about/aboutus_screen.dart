import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutUs extends StatelessWidget{
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
          "About Us",
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
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children:[
           /* const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Text('About the app',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'main' ),),
                ],
              ),
            ),*/
            const SizedBox(height: 10),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/img/img.png'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child:  Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white, // You can add a background color if needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Shadow color (you can make it darker for more emphasis)
                      blurRadius: 10, // Shadow blur radius
                      offset: const Offset(0, 4), // Shadow position, adjust to your liking
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(9.0), // Increased padding for more spacing around text
                  child: RichText(
                    text: const TextSpan(
                      text: 'About Company\n\n',
                      style: TextStyle(color: Colors.black87, fontSize: 17, fontFamily: 'main'),
                      children: <TextSpan>[
                       /* TextSpan(
                          text: 'You have received a payment\nfrom Aron Finc.\n\n',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),*/
                        TextSpan(
                          text: 'Plus91 Technologies Pvt Ltd is a credible Global Digital Healthcare innovator. Plus91 Technologies Pvt Ltd collaborates with local stakeholders to meaningfully improve healthcare delivery systems all over the world.',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, ),
              child:  Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white, // You can add a background color if needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Shadow color (you can make it darker for more emphasis)
                      blurRadius: 10, // Shadow blur radius
                      offset: const Offset(0, 4), // Shadow position, adjust to your liking
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(9.0), // Increased padding for more spacing around text
                  child: RichText(
                    text: const TextSpan(
                      text: 'MediXcel\n\n',
                      style: TextStyle(color: Colors.black87, fontSize: 17, fontFamily: 'main'),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'MediXcel Lite caters to the data collection, management and reporting needs within resource constrained environments.',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white, // You can add a background color if needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Shadow color (you can make it darker for more emphasis)
                      blurRadius: 10, // Shadow blur radius
                      offset: const Offset(0, 4), // Shadow position, adjust to your liking
                    ),
                  ],
                ),
                child: const Padding(
                  padding:  EdgeInsets.all(16.0),
                  child:  Row(
                    children: [
                      Icon(CupertinoIcons.globe,color: Colors.blueAccent,),
                      Text('    WWW.Plus91Online.com',style: TextStyle(color: Colors.black54, fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white, // You can add a background color if needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Shadow color (you can make it darker for more emphasis)
                      blurRadius: 10, // Shadow blur radius
                      offset: const Offset(0, 4), // Shadow position, adjust to your liking
                    ),
                  ],
                ),
                child: const Padding(
                  padding:  EdgeInsets.all(16.0),
                  child:  Row(
                    children: [
                      Icon(CupertinoIcons.building_2_fill,color: Colors.blueAccent,),
                      Text('    Plus91 Techonology Pvt Ltd',style: TextStyle(color: Colors.black54, fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white, // You can add a background color if needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Shadow color (you can make it darker for more emphasis)
                      blurRadius: 10, // Shadow blur radius
                      offset: const Offset(0, 4), // Shadow position, adjust to your liking
                    ),
                  ],
                ),
                child: const Padding(
                  padding:  EdgeInsets.all(16.0),
                  child:  Row(
                    children: [
                      Icon(CupertinoIcons.location_solid,color: Colors.blueAccent,),
                      Text('    Plus91 Techonology Pvt Ltd,601/A\n    East Court,Next to Phoenix Market\n    City,Off, Nagar Road,Viman',style: TextStyle(color: Colors.black54, fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0,bottom: 16),
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white, // You can add a background color if needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Shadow color (you can make it darker for more emphasis)
                      blurRadius: 10, // Shadow blur radius
                      offset: const Offset(0, 4), // Shadow position, adjust to your liking
                    ),
                  ],
                ),
                child: const Padding(
                  padding:  EdgeInsets.all(16.0),
                  child:  Row(
                    children: [
                      Icon(Icons.phone_android, color: Colors.blueAccent,),
                      Text('    V2.5.3.01',style: TextStyle(color: Colors.black54, fontSize: 12),),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),

      ),
      /*bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
        ],
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),*/
    );
  }
}