import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobPostPage extends StatefulWidget {
  @override
  _JobPostPageState createState() => _JobPostPageState();
}

class _JobPostPageState extends State<JobPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;
  final Map<String, TextEditingController> _controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
    'company': TextEditingController(),
    'location': TextEditingController(),
    'salary': TextEditingController(),
    'experience': TextEditingController(),
    'applyLink': TextEditingController(),
  };
  String _jobType = 'Full-time';
  bool _isSubmitting = false;

  final List<String> _jobTypes = [
    'Full-time', 'Part-time', 'Internship', 'Contract', 'Remote'
  ];

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _submitJobPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _supabase.from('job_postings').insert({
        'alumni_id': user.id,
        'title': _controllers['title']!.text.trim(),
        'description': _controllers['description']!.text.trim(),
        'company': _controllers['company']!.text.trim(),
        'location': _controllers['location']!.text.trim(),
        'salary': _controllers['salary']!.text.trim(),
        'experience_required': _controllers['experience']!.text.trim(),
        'apply_link': _controllers['applyLink']!.text.trim(),
        'posted_at': DateTime.now().toIso8601String(),
        'job_type': _jobType,
      });
      
      if (mounted) {
        _showSuccessDialog();
        _formKey.currentState!.reset();
      }
    } catch (e) {
      if (mounted) _showErrorSnackbar(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Icon(Icons.check_circle, color: Color.fromARGB(255, 108, 69, 166), size: 48),
        title: Text('Success!', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Job posting created successfully'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Color.fromARGB(255, 108, 69, 166))),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${error.replaceAll('Exception: ', '')}'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Job Post', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor:Color.fromARGB(255, 108, 69, 166),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('title', 'Job Title*', Icons.work),
                _buildTextField('description', 'Description*', Icons.description, maxLines: 4),
                _buildTextField('company', 'Company Name*', Icons.business),
                _buildTextField('location', 'Location*', Icons.location_on),
                _buildJobTypeDropdown(),
                Row(
                  children: [
                    Expanded(child: _buildTextField('salary', 'Salary', Icons.attach_money, keyboardType: TextInputType.number)),
                    SizedBox(width: 15),
                    Expanded(child: _buildTextField('experience', 'Experience', Icons.work_history)),
                  ],
                ),
                _buildTextField('applyLink', 'Application Link*', Icons.link, keyboardType: TextInputType.url),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitJobPost,
                    icon: _isSubmitting ? CircularProgressIndicator(color: Colors.white) : Icon(Icons.send),
                    label: Text(_isSubmitting ? 'Posting...' : 'Publish Job Post',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor:Color.fromARGB(255, 108, 69, 166),
                      foregroundColor: const Color.fromARGB(255, 251, 250, 251),
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

  Widget _buildTextField(String key, String label, IconData icon, {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: _controllers[key],
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color:Color.fromARGB(255, 108, 69, 166)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) => (label.contains('*') && (value == null || value.isEmpty)) ? 'This field is required' : null,
      ),
    );
  }

  Widget _buildJobTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: _jobType,
        decoration: InputDecoration(
          labelText: 'Job Type',
          prefixIcon: Icon(Icons.schedule, color: Color.fromARGB(255, 108, 69, 166)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: _jobTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
        onChanged: (value) => setState(() => _jobType = value!),
      ),
    );
  }
}