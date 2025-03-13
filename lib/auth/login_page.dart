import 'package:flutter/material.dart';
import 'package:upskill_app/app_users/alumni/alumni_home.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upskill_app/auth/roles.dart'; // Import Roles page
import '../app_users/admin/admin_home.dart';
import '../app_users/students/home/students_home.dart';
import '../app_users/teacher/teacher_home.dart';  // Student home page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Login function
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in the user
      await authService.signInWithEmailPassword(email, password);

      // Get the current logged-in user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User is not logged in');
      }

      // Query the 'user_names' table to check if the email exists
      final response = await Supabase.instance.client
          .from('user_names')
          .select('email, role')  // Assuming 'email' and 'role' columns exist
          .eq('email', email)
          .single();

      // Check if the email is found in the user_names table and get role
      if (response != null && response['role'] != null) {
        final role = response['role'];

        // Navigate to the appropriate home page based on the role
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHome()),
          );
        } else if (role == 'student') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentsHome()),
          );}else if (role == 'teacher') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TeacherHome()),
          );}else if (role == 'alumini') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AlumniHome()),
          );
        }
      } else {
        // If email is not found or role is not set, navigate to Roles page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Roles()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), leading: Icon(Icons.account_box_sharp)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Color.fromARGB(255, 81, 94, 104)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
