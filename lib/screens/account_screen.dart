import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Screen"), // App bar title
      ),
      body: const Center(
        child: Text(
          "Account Screen",
          style: TextStyle(
            fontSize: 24, // Font size
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.blue, // Text color
          ),
        ),
      ),
    );
  }
}
