import 'package:flutter/material.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upskill_app/auth/roles.dart'; // Import Supabase

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Roles()),
      );

      // Get the current logged-in user's ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User is not logged in');
      }


    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), leading: Icon(Icons.account_box_sharp),),
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
