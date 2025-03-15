import 'package:flutter/material.dart';

class AlumniProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(height: 16),
            Text('Name: John Doe', style: TextStyle(fontSize: 20)),
            Text('Role: Alumni', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action to edit profile
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Edit Profile clicked!'),
                ));
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
