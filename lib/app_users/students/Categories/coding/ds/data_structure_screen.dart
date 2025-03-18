import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'easy.dart';
import 'hard.dart';
import 'medium.dart';

class DataStructureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Structures Course'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // YouTube Video Thumbnail and Button
            GestureDetector(
              onTap: () => _launchURL('https://youtu.be/RBSGKlAvoiM?si=Y0vZCOlpwAH14QsJ'),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://img.youtube.com/vi/RBSGKlAvoiM/0.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL('https://youtu.be/RBSGKlAvoiM?si=Y0vZCOlpwAH14QsJ'),
              child: Text('Watch on YouTube'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
            ),
            SizedBox(height: 20),

            // Difficulty Level Containers
            DifficultyLevelButton(level: 'Easy', context: context),
            DifficultyLevelButton(level: 'Medium', context: context),
            DifficultyLevelButton(level: 'Hard', context: context),
          ],
        ),
      ),
    );
  }

  // Method to launch URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// Difficulty Level Button Widget
class DifficultyLevelButton extends StatelessWidget {
  final String level;
  final BuildContext context;

  DifficultyLevelButton({required this.level, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (level == 'Easy') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EasyLevelScreen(),
            ),
          );
        } else if (level == 'Medium') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MediumLevelScreen(),
            ),
          );
        } else if (level == 'Hard') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HardLevelScreen(),
            ),
          );
        }
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
            Text(
              level,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}