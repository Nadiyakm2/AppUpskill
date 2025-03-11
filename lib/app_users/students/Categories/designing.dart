import 'package:flutter/material.dart';

class DesigningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Designing Courses'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseTile(courseName: 'UI/UX', imagePath: 'assets/uiux.png', page: UIUXScreen()),
            CourseTile(courseName: 'Graphics', imagePath: 'assets/graphics.png', page: GraphicsScreen()),
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

class UIUXScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('UI/UX Course')),
      body: Center(child: Text('UI/UX Course Content Here')),
    );
  }
}

class GraphicsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Graphics Course')),
      body: Center(child: Text('Graphics Course Content Here')),
    );
  }
}
