import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class Roles extends StatefulWidget {
  const Roles({super.key});

  @override
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  String? selectedRole;
  final List<String> roles = ['teacher', 'admin', 'student', 'alumini'];

  @override
  void initState() {
    super.initState();
  }

  // Function to store the role in Supabase without execute(), data, or error
  Future<void> storeRoleInSupabase(String role) async {
    final userId = Supabase.instance.client.auth.currentUser?.id; // Assuming the user is logged in

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User is not logged in')));
      return;
    }

    try {
      // Use the `upsert` without .execute()
      final response = await Supabase.instance.client
          .from('roles') // Assuming a table called 'roles'
          .upsert({
        'user_id': userId, // Store the user's ID
        'role': role, // Store the selected role
      })
          .select();  // Adding select to get back a valid response

      // Check if the response is null
      if (response == null) {
        throw Exception('No response from Supabase');
      }

      // Successfully saved the role and got a response
      // After success, navigate based on the role
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
        Navigator.pushNamed(context, '/teacher_home');
        break;
      case 'admin':
        Navigator.pushNamed(context, '/admin_home');
        break;
      case 'student':
        Navigator.pushNamed(context, '/student_home');
        break;
      case 'alumini':
        Navigator.pushNamed(context, '/alumni_home');
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedRole,
              hint: Text('Select Role'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue;
                });
              },
              items: roles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedRole == null
                  ? null
                  : () async {
                // Store the role in Supabase and navigate based on the role
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
