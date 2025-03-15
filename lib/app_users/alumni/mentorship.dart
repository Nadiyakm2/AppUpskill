import 'package:flutter/material.dart';

class MentorshipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentorship'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Mentorship Page!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action to request mentorship
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Mentorship request sent!'),
                ));
              },
              child: Text('Request Mentorship'),
            ),
          ],
        ),
      ),
    );
  }
}
