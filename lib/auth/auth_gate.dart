import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upskill_app/auth/register_page.dart';
import '../app_users/admin/admin_home.dart';
import '../app_users/alumni/alumni_home.dart';
import '../app_users/students/home/students_home.dart';
import '../app_users/teacher/teacher_home.dart';
import 'login_page.dart';
import 'package:upskill_app/auth/roles.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Show loading indicator while waiting for authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check for valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          // Check the role of the user if the session is not null
          return FutureBuilder<Map<String, dynamic>?>(
            future: _getUserRole(session.user?.id),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator if fetching the role
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (roleSnapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${roleSnapshot.error}')),
                );
              }

              // Check the role returned from the database
              final role = roleSnapshot.data?['role'];
              if (role == null) {
                // If no role is found, redirect to the role selection page
                return const Roles();
              }

              // Navigate based on the role
              return _navigateToRolePage(role);
            },
          );
        } else {
          // If no session, redirect to login page
          return const LoginPage();
        }
      },
    );
  }

  // Function to fetch the role of the user from 'user_roles' table
  Future<Map<String, dynamic>?> _getUserRole(String? userId) async {
    if (userId == null) {
      return null;
    }

    try {
      final response = await Supabase.instance.client
          .from('user_roles') // Assuming a table called 'user_roles'
          .select('role')
          .eq('user_id', userId)
          .single(); // Fetch a single record (role) for the user

      if (response == null) {
        return null; // If no role is found
      }

      return response;
    } catch (e) {
      return null; // Return null in case of error
    }
  }

  // Function to navigate based on the role
  Widget _navigateToRolePage(String role) {
    switch (role) {
      case 'admin':
        return const AdminHome(); // Admin Home Page
      case 'student':
        return  StudentsHome(); // Student Home Page
      case 'teacher':
        return const TeacherHome(); // Teacher Home Page
      case 'alumni':
        return const AlumniHome(); // Alumni Home Page
      default:
        return const Roles(); // Navigate to role selection page if unknown role
    }
  }
}
