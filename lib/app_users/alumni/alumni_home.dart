import 'package:flutter/material.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/login_page.dart';

class AlumniHome extends StatefulWidget {
  const AlumniHome({super.key});

  @override
  State<AlumniHome> createState() => _AlumniHomeState();
}

class _AlumniHomeState extends State<AlumniHome> {
  final authService = AuthService();

  // Log out function
  void logout() async {
    await authService.signOut();  // Sign the user out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumni Dashboard'),
        actions: [
          IconButton(
            onPressed: logout,  // Log out when the icon is pressed
            icon: const Icon(
              Icons.logout,
              color:  Color(0xffa88979),
            ),
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome, Alumni!'),
      ),
    );
  }
}