import 'package:flutter/material.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Get auth service instance
  final authService = AuthService();

  // Text field controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Track loading state
  bool _isLoading = false;

  // Login function
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      // Sign in the user
      await authService.signInWithEmailPassword(email, password);

      // Get the current logged-in user's ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User is not logged in');
      }

      // Check if the user has a role in the 'user_roles' table
      final response = await Supabase.instance.client
          .from('user_roles') // 'user_roles' table
          .select('role')
          .eq('user_id', user.id)
          .single() // Get the first result (user should have only one role)
          .then((data) {
        return data;
      }).catchError((e) {
        return null; // Return null in case of error
      });

      if (response == null) {
        throw Exception('No role found for the user');
      }

      final role = response['role'];

      // Redirect user based on their role
      navigateToRolePage(role);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  // Navigate to different pages based on the role
  void navigateToRolePage(String role) {
    switch (role) {
      case 'teacher':
        Navigator.pushReplacementNamed(context, '/teacher_home');
        break;
      case 'admin':
        Navigator.pushReplacementNamed(context, '/admin_home');
        break;
      case 'student':
        Navigator.pushReplacementNamed(context, '/student_home');
        break;
      case 'alumni':
        Navigator.pushReplacementNamed(context, '/alumni_home');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unknown role')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
