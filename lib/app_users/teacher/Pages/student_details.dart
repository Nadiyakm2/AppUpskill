import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentProfilesPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchStudents() async {
    final response = await Supabase.instance.client.from('students').select();

    return response as List<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profiles'),
        backgroundColor: Color(0xFFE6E6FA),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students available.'));
          } else {
            final students = snapshot.data!;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final skills = student['skills'] is List
                    ? (student['skills'] as List).join(', ')
                    : 'No skills listed';

                return Card(
                  color: Color(0xFFADD8E6),
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(student['name'] ?? 'No Name'),
                    subtitle: Text('Skills: $skills'),
                    trailing: IconButton(
                      icon: Icon(Icons.feedback),
                      onPressed: () {
                        // Navigate to feedback page
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
