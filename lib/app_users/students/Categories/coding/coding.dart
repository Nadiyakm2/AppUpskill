import 'package:flutter/material.dart';
import 'package:upskill_app/app_users/students/Categories/coding/python/python_screen.dart';
import 'c/C_screen.dart';
import 'ds/data_structure_screen.dart';
import 'java/java_screen.dart';

class CodingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coding Courses'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseTile(
              courseName: 'Java',
              imagePath: 'assets/java.png',
              page: JavaScreen(), // Navigate to JavaScreen when tapped
            ),
            CourseTile(
              courseName: 'C',
              imagePath: 'assets/c.png',
              page: JavaScreen(), // Navigate to CScreen when tapped
            ),
            CourseTile(
              courseName: 'Python',
              imagePath: 'assets/python.png',
              page: PythonScreen(), // Navigate to PythonScreen when tapped
            ),
            CourseTile(
              courseName: 'Data Structures',
              imagePath: 'assets/data_structure.png',
              page: CScreen(), // Navigate to DataStructureScreen when tapped
            ),
          ],
        ),
      ),
    );
  }
}

class CourseTile extends StatelessWidget {
  final String courseName;
  final String imagePath;
  final Widget page;

  CourseTile({required this.courseName, required this.imagePath, required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page), // Navigates to the corresponding screen
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purple.withOpacity(0.7)], // Purple to Pink gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 6.0, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath), // Course image
            ),
            SizedBox(width: 10),
            Text(
              courseName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white), // Arrow icon
          ],
        ),
      ),
    );
  }
}
