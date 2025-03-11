import 'package:flutter/material.dart';

class CodingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coding Courses'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseTile(courseName: 'Java', imagePath: 'assets/java.png', page: JavaScreen()),
            CourseTile(courseName: 'C', imagePath: 'assets/c.png', page: CScreen()),
            CourseTile(courseName: 'Python', imagePath: 'assets/python.png', page: PythonScreen()),
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
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
          ),
          title: Text(courseName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}

class JavaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Java Course')),
      body: Center(child: Text('Java Course Content Here')),
    );
  }
}

class CScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('C Course')),
      body: Center(child: Text('C Course Content Here')),
    );
  }
}

class PythonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Python Course')),
      body: Center(child: Text('Python Course Content Here')),
    );
  }
}
