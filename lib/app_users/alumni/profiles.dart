import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AlumniProfileScreen extends StatefulWidget {
  @override
  _AlumniProfileScreenState createState() => _AlumniProfileScreenState();
}

class _AlumniProfileScreenState extends State<AlumniProfileScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _editMode = false;
  Map<String, dynamic>? _profileData;

  // Controllers
  final _headlineController = TextEditingController();
  final _summaryController = TextEditingController();
  final _skillsController = TextEditingController();
  final _linkedinController = TextEditingController();

  // Dropdown values
  final List<String> _industries = [
    'Software Development', 'Data Science', 'Cybersecurity', 'Business', 'Other'
  ];
  String _selectedIndustry = 'Software Development';
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await _supabase.from('alumni_profiles')
          .select()
          .eq('user_id', user.id)
          .single();

      setState(() {
        _profileData = response;
        _headlineController.text = _profileData?['headline'] ?? '';
        _summaryController.text = _profileData?['summary'] ?? '';
        _skillsController.text = _profileData?['skills']?.join(', ') ?? '';
        _linkedinController.text = _profileData?['linkedin_url'] ?? '';
        _selectedIndustry = _profileData?['industry'] ?? _industries.first;
        _avatarUrl = _profileData?['avatar_url'];
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching profile data: $error');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _supabase.auth.currentUser;
    if (user == null) return;
    final userId = user.id;

    final profileUpdate = {
      'user_id': user.id,
      'headline': _headlineController.text,
      'industry': _selectedIndustry,
      'summary': _summaryController.text,
      'skills': _skillsController.text.split(',').map((s) => s.trim()).toList(),
      'linkedin_url': _linkedinController.text,
      'updated_at': DateTime.now().toIso8601String(),
      'avatar_url': _avatarUrl,
    };

    try {
      await _supabase.from('alumni_profiles').upsert(profileUpdate);
      setState(() => _editMode = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
      );
    } catch (error) {
      debugPrint('Error updating profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _avatarUrl = pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alumni Profile')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildAvatarSection(),
                    _buildTextField('Headline', _headlineController),
                    _buildIndustrySelector(),
                    _buildTextField('Summary', _summaryController, maxLines: 3),
                    _buildTextField('Skills (comma-separated)', _skillsController),
                    _buildTextField('LinkedIn URL', _linkedinController),
                    SizedBox(height: 20),
                    _buildActionButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _editMode ? _pickImage : null,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _avatarUrl != null ? AssetImage(_avatarUrl!) : null,
            child: _avatarUrl == null ? Icon(Icons.person, size: 50) : null,
          ),
        ),
        if (_editMode)
          TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.camera_alt),
            label: Text('Change Profile Picture'),
          ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        maxLines: maxLines,
        enabled: _editMode,
        validator: (value) => value!.isEmpty ? 'This field cannot be empty' : null,
      ),
    );
  }

  Widget _buildIndustrySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField(
        value: _selectedIndustry,
        items: _industries.map((industry) => DropdownMenuItem(value: industry, child: Text(industry))).toList(),
        onChanged: _editMode ? (value) => setState(() => _selectedIndustry = value as String) : null,
        decoration: InputDecoration(labelText: 'Industry', border: OutlineInputBorder()),
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: _editMode ? _saveProfile : () => setState(() => _editMode = true),
      child: Text(_editMode ? 'Save' : 'Edit Profile'),
    );
  }
}