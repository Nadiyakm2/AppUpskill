import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_page.dart'; // Import Supabase

class Roles extends StatefulWidget {
  const Roles({super.key});

  @override
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  String? selectedRole;
  String? userName; // To store the entered name
  String? code; // To store the entered code
  final List<String> roles = ['teacher', 'admin', 'student', 'alumni'];

  // The code for teacher and admin
  final Map<String, String> roleCodes = {
    'teacher': 'TeaCoffee',
    'admin': 'Tawakkul',
  };

  // Function to store the role, email, and name in Supabase
  Future<void> storeRoleInSupabase(String role) async {
    final user = Supabase.instance.client.auth.currentUser; // Get the current logged-in user

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User is not logged in')));
      return;
    }

    final userEmail = user.email; // Get the user's email
    final userId = user.id; // Get the user's ID

    // Validate if the user has entered their name
    if (userName == null || userName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter your name')));
      return;
    }

    try {
      // Use the `upsert` to store the role, email, and name in the 'user_names' table
      final response = await Supabase.instance.client
          .from('user_names') // The new table 'user_names'
          .upsert({
        'user_id': userId, // Store the user's ID
        'role': role, // Store the selected role
        'email': userEmail, // Store the user's email
        'name': userName, // Store the entered name
      })
          .select();  // Adding select to get a valid response

      // Check if the response is null
      if (response == null) {
        throw Exception('No response from Supabase');
      }

      // Successfully saved the role, email, and name, now navigate based on the role
      navigateToRolePage(role);
    } catch (e) {
      // Handle any error that may occur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Navigate to different pages based on the role
  void navigateToRolePage(String role) {
    switch (role) {
      case 'teacher':
        Navigator.pushNamed(context, '/TeacherHome');
        break;
      case 'admin':
        Navigator.pushNamed(context, '/AdminHome');
        break;
      case 'student':
        Navigator.pushNamed(context, '/StudentsHome');
        break;
      case 'alumni':
        Navigator.pushNamed(context, '/AluminiHome');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unknown role')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Role"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Replace the current screen with the LoginPage when the back button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input for the user's name
            TextField(
              onChanged: (value) {
                setState(() {
                  userName = value; // Update the userName when the text field changes
                });
              },
              decoration: const InputDecoration(labelText: 'Enter your Name'),
            ),
            SizedBox(height: 20),

            // Dropdown for selecting the role
            DropdownButton<String>(
              value: selectedRole,
              hint: Text('Select Role'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue;
                  code = null; // Reset code field when the role changes
                });
              },
              items: roles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            // Show a code input field if the user selects "admin" or "teacher"
            if (selectedRole == 'admin' || selectedRole == 'teacher')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      code = value; // Update the code when the text field changes
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Code',
                    hintText: selectedRole == 'admin' ? 'Code for Admin' : 'Code for Teacher',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

            SizedBox(height: 20),

            // Confirm button to store the role and navigate
            ElevatedButton(
              onPressed: selectedRole == null || userName == null || userName!.isEmpty
                  ? null
                  : () async {
                // Check if a code is required and if it's correct
                if ((selectedRole == 'teacher' && code != roleCodes['teacher']) ||
                    (selectedRole == 'admin' && code != roleCodes['admin'])) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Incorrect code')),
                  );
                  return;
                }

                // Store the role, email, and name in Supabase and navigate based on the role
                await storeRoleInSupabase(selectedRole!);
              },
              child: Text("Confirm Role"),
            ),
          ],
        ),
      ),
    );
  }
}
