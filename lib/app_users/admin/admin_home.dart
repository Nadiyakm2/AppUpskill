import 'package:flutter/material.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/login_page.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) =>  LoginPage()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome, Admin!'),
      ),
    );
  }
}