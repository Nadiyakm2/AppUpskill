import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;  // Store user data
  bool _isLoading = true;  // Track loading state

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    print("Fetching user data...");
    try {
      final user = Supabase.instance.client.auth.currentUser;
      print("User Data: $user");

      if (user == null) {
        print("No user data found!");
      }

      setState(() {
        _user = user;
        _isLoading = false;  // Stop loading when data is set
      });
    } catch (e) {
      print("Error fetching user: $e");
      setState(() {
        _isLoading = false;  // Stop loading even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()  // Show loading indicator
            : _user == null
                ? Text("No user data found! Please log in again.")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome, ${_user!.email}"),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await Supabase.instance.client.auth.signOut();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  ),
      ),
    );
  }
}
