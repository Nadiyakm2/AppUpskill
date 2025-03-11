import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController postController = TextEditingController();

  Future<void> addPost() async {
    final studentId = supabase.auth.currentUser?.id;
    await supabase.from('posts').insert({
      'student_id': studentId,
      'content': postController.text,
      'timestamp': DateTime.now().toIso8601String()
    });
    postController.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post added!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Achievement")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: postController,
              decoration: InputDecoration(labelText: "Share your achievement"),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: addPost, child: Text("Post"))
          ],
        ),
      ),
    );
  }
}
