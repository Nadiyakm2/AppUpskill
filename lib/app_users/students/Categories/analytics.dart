import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Courses'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseTile(courseName: 'Data Analytics', imagePath: 'assets/data_analytics.png', page: DataAnalyticsScreen()),
            CourseTile(courseName: 'Business Analytics', imagePath: 'assets/business_analytics.png', page: BusinessAnalyticsScreen()),
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

class DataAnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Analytics Course')),
      body: Center(child: Text('Data Analytics Course Content Here')),
    );
  }
}

class BusinessAnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Business Analytics Course')),
      body: Center(child: Text('Business Analytics Course Content Here')),
    );
  }
}
