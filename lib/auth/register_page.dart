import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/app_users/students/home/students_home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _agreeToTerms = false;
  String? selectedRole;

  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  final List<String> roles = ['admin', 'teacher', 'alumni', 'student'];

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Enter your email";
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(value) ? null : "Please enter a valid email address";
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Enter your password";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return "Confirm your password";
    if (value != _passwordController.text) return "Passwords do not match";
    return null;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) return "Enter your name";
    return null;
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      _showSnackbar("You must agree to the terms and conditions");
      return;
    }

    if (selectedRole == null || !roles.contains(selectedRole)) {
      _showSnackbar("Please select a valid role");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();

      // Step 1: Register the user with Supabase Auth
      final AuthResponse response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final User? user = response.user;
      if (user == null) {
        throw Exception('User registration failed');
      }

      // Step 2: Insert the user's profile into the `user_profiles` table
      await Supabase.instance.client.from('user_profiles').upsert({
        'user_id': user.id,
        'name': name,
        'email': email,
        'role': selectedRole,
      });

      print("✅ User registered successfully with name: $name and role: $selectedRole");

      // Step 3: Navigate based on role
      _navigateBasedOnRole(selectedRole!);
    } catch (e) {
      print('🚨 Register error: $e');
      _handleError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case 'student':
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StudentsHome()));
        break;
      case 'admin':
        // Navigate to admin home page
        _showSnackbar("Admin home page not implemented yet");
        break;
      case 'teacher':
        // Navigate to teacher home page
        _showSnackbar("Teacher home page not implemented yet");
        break;
      case 'alumni':
        // Navigate to alumni home page
        _showSnackbar("Alumni home page not implemented yet");
        break;
      default:
        _showSnackbar("Invalid role");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleError(dynamic error) {
    String errorMessage = 'An unexpected error occurred';
    if (error is AuthException) {
      switch (error.message) {
        case 'Email already in use':
          errorMessage = 'This email is already registered. Please log in.';
          break;
        case 'Weak password':
          errorMessage = 'Your password is too weak. Please choose a stronger password.';
          break;
        default:
          errorMessage = error.message ?? errorMessage;
      }
    } else if (error is PostgrestException) {
      errorMessage = 'Database error: ${error.message}';
    }
    _showSnackbar(errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 95, 172, 228), const Color.fromARGB(255, 172, 97, 247)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: _nameValidator,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Select Role',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        hint: const Text("Choose a role"),
                        items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                        onChanged: (value) => setState(() => selectedRole = value),
                        validator: (value) => value == null ? "Select a role" : null,
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField('Password', _passwordController, _passwordValidator),
                      const SizedBox(height: 16),
                      _buildPasswordField('Confirm Password', _confirmPasswordController, _confirmPasswordValidator),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                          ),
                          const Text("I agree to the "),
                          TextButton(
                            onPressed: () {
                              // Navigate to terms and conditions page
                            },
                            child: const Text(
                              'terms and conditions',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AnimatedBuilder(
                        animation: _buttonController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _buttonScaleAnimation.value,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _register,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.blue.shade900,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text('Register', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
      validator: validator,
    );
  }
}