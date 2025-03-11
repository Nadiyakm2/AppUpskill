import 'package:flutter/material.dart';

class MarketingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketing Courses'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseTile(courseName: 'Digital Marketing', imagePath: 'assets/digital_marketing.png', page: DigitalMarketingScreen()),
            CourseTile(courseName: 'SEO', imagePath: 'assets/seo.png', page: SEOScreen()),
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

class DigitalMarketingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digital Marketing Course')),
      body: Center(child: Text('Digital Marketing Course Content Here')),
    );
  }
}

class SEOScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SEO Course')),
      body: Center(child: Text('SEO Course Content Here')),
    );
  }
}
