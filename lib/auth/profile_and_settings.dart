import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/login_page.dart';

class ProfileAndSettingsScreen extends StatefulWidget {
  @override
  _ProfileAndSettingsScreenState createState() => _ProfileAndSettingsScreenState();
}

class _ProfileAndSettingsScreenState extends State<ProfileAndSettingsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final response = await Supabase.instance.client
          .from('user_profiles')
          .select('name, email')
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        _nameController.text = response['name'] ?? '';
        _emailController.text = response['email'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await Supabase.instance.client
          .from('user_profiles')
          .upsert({
            'user_id': userId,
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleNotifications(bool value) {
    setState(() => _notificationsEnabled = value);
    // Save notification preference to the database or local storage
  }

  void _toggleDarkMode(bool value) {
    setState(() => _darkModeEnabled = value);
    // Apply dark/light theme
  }

  Future<void> _logOut() async {
    await AuthService().logOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile & Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  Text(
                    'Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/default_profile.png'),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 32),

                  // Settings Section
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Enable Notifications'),
                    value: _notificationsEnabled,
                    onChanged: _toggleNotifications,
                  ),
                  SwitchListTile(
                    title: Text('Dark Mode'),
                    value: _darkModeEnabled,
                    onChanged: _toggleDarkMode,
                  ),
                  SizedBox(height: 32),

                  // Log Out Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _logOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: Text('Log Out'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}