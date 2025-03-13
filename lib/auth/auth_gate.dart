import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Onboarding/onboarding_screen.dart';
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
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Show loading indicator while waiting for authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Get the current session from snapshot data
        final session = snapshot.data?.session;

        // If there is no session, show the login page
        if (session == null) {
          return OnboardingScreen();
        }

        // If session is valid, check the user's role from the 'user_names' table
        return FutureBuilder<Map<String, dynamic>?>(
          future: _getUserRole(session.user?.email),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (roleSnapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error: ${roleSnapshot.error}')),
              );
            }

            // Get the role from the response
            final role = roleSnapshot.data?['role'];

            // If no role is found, return to the role selection page
            if (role == null) {
              return const Roles(); // Navigate to role selection page if no role is set
            }

            // Navigate based on the role
            return _navigateToRolePage(role);
          },
        );
      },
    );
  }

  // Function to fetch the user's role from the 'user_names' table based on their email
  Future<Map<String, dynamic>?> _getUserRole(String? email) async {
    if (email == null) {
      return null;
    }

    try {
      final response = await Supabase.instance.client
          .from('user_names') // Your table that holds user roles
          .select('role') // Assuming the 'role' column stores the role of the user
          .eq('email', email) // Use email to fetch the role
          .single(); // Fetch a single record (role) for the user

      if (response == null) {
        return null; // If no role is found
      }

      return response;
    } catch (e) {
      print("❌ Error fetching role: $e");
      return null; // Return null in case of error
    }
  }

  // Function to navigate based on the role
  Widget _navigateToRolePage(String role) {
    switch (role) {
      case 'admin':
        return const AdminHome(); // Admin Home Page
      case 'student':
        return StudentsHome(); // Student Home Page
      case 'teacher':
        return const TeacherHome(); // Teacher Home Page
      case 'alumni':
        return const AlumniHome(); // Alumni Home Page
      default:
        return const Roles(); // Navigate to role selection page if unknown role
    }
  }
}
