import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseManagementPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final response = await Supabase.instance.client
        .from('courses')
        .select();

    return response as List<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Management'),
        backgroundColor: Color(0xFFE6E6FA),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No courses available.'));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  color: Color(0xFF90EE90),
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(course['title'] ?? 'No Title'),
                    subtitle: Text(course['description'] ?? 'No Description'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit course page
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add course page
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
