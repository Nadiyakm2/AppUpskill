import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upskill_app/app_users/alumni/alumni_home.dart';
import 'package:upskill_app/app_users/teacher/teacher_home.dart';
import 'package:upskill_app/auth/login_page.dart';
import 'package:upskill_app/app_users/admin/admin_home.dart';
import 'package:upskill_app/app_users/students/home/students_home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // Fetch user role from the 'profiles' table
  Future<String?> _getUserRole() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await Supabase.instance.client
          .from('profiles') // Ensure this table has a 'role' column
          .select('role')
          .eq('id', userId)
          .single();

      // Ensure the response contains 'role'
      if (response != null && response['role'] != null) {
        return response['role'] as String?;
      }
      return null; // Explicitly return null if role is not found
    } catch (e) {
      print('Error fetching user role: $e');
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('An error occurred. Please try again.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Retry logic
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const AuthGate()),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final session = Supabase.instance.client.auth.currentSession;
        if (session == null) {
          return const LoginPage();
        }

        return FutureBuilder<String?>(
          future: _getUserRole(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (roleSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Error fetching role. Please try again later.',
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await Supabase.instance.client.auth.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const AuthGate()),
                          );
                        },
                        child: const Text('Log Out and Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final role = roleSnapshot.data;

            if (role == null) {
              return const Scaffold(
                body: Center(
                  child: Text(
                    'User role not found. Please contact support.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            switch (role) {
              case 'admin':
                return AdminHome();
              case 'teacher':
                return TeacherHome();
              case 'alumni':
                return AlumniHome();
              case 'student':
                return StudentsHome();
              default:
                return const Scaffold(
                  body: Center(
                    child: Text('Invalid role detected. Please log in again.'),
                  ),
                );
            }
          },
        );
      },
    );
  }
}