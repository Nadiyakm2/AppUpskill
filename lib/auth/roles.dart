import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Roles extends StatefulWidget {
  const Roles({super.key});

  @override
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  String? selectedRole;
  String? userName;
  String? code;
  final List<String> roles = ['Teacher', 'Admin', 'Student', 'Alumni'];

  final Map<String, String> roleCodes = {
    'teacher': 'TeaCoffee',
    'admin': 'Tawakkul',
  };

  Future<void> storeRoleInSupabase(String role) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return;
    }
    if (userName == null || userName!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('user_names').upsert({
        'user_id': user.id,
        'role': role,
        'email': user.email,
        'name': userName!.trim(),
      });
      navigateToRolePage(role);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void navigateToRolePage(String role) {
    final roleRoutes = {
      'Teacher': '/TeacherHome',
      'Admin': '/AdminHome',
      'Student': '/StudentsHome',
      'Alumni': '/AlumniHome',
    };

    Navigator.pushReplacementNamed(context, roleRoutes[role] ?? '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.purple[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Select Your Role",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          onChanged: (value) => setState(() => userName = value),
                          decoration: InputDecoration(
                            labelText: 'Enter your Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          hint: const Text("Select Role"),
                          value: selectedRole,
                          items: roles.map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedRole = newValue;
                              code = null;
                            });
                          },
                        ),
                        if (selectedRole == 'Admin' || selectedRole == 'Teacher')
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextField(
                              onChanged: (value) => setState(() => code = value),
                              decoration: InputDecoration(
                                labelText: 'Enter Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              obscureText: true,
                            ),
                          ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: selectedRole == null || userName == null || userName!.trim().isEmpty
                              ? null
                              : () async {
                                  final roleKey = selectedRole?.toLowerCase();
                                  if (roleCodes.containsKey(roleKey) && code != roleCodes[roleKey]) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Incorrect code')),
                                    );
                                    return;
                                  }
                                  await storeRoleInSupabase(selectedRole!);
                                },
                          style: ElevatedButton.styleFrom(
                          backgroundColor:const Color.fromARGB(255, 128, 103, 173), // A balanced color matching the theme

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const Text(
                            "Confirm Role",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
