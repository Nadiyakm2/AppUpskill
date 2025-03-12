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

  // Function to store the role and email in Supabase
  Future<void> storeRoleInSupabase(String role) async {
    final user = Supabase.instance.client.auth.currentUser; // Get the current logged-in user

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User is not logged in')));
      return;
    }

    final userEmail = user.email; // Get the user's email
    final userId = user.id; // Get the user's ID

    try {
      // Use the `upsert` to store the role and email in the 'user_roles' table
      final response = await Supabase.instance.client
          .from('user_roles') // Change 'roles' to 'user_roles'
          .upsert({
        'user_id': userId, // Store the user's ID
        'role': role, // Store the selected role
        'email': userEmail, // Store the user's email
      })
          .select();  // Adding select to get a valid response

      // Check if the response is null
      if (response == null) {
        throw Exception('No response from Supabase');
      }

      // Successfully saved the role and email, now navigate based on the role
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
                // Store the role and email in Supabase and navigate based on the role
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
