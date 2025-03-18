import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizManagementPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchQuizzes() async {
    final response = await Supabase.instance.client
        .from('quizzes')
        .select();

    return response as List<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Management'),
        backgroundColor: Color(0xFFE6E6FA),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No quizzes available.'));
          } else {
            final quizzes = snapshot.data!;
            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return Card(
                  color: Color(0xFFFFD700),
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(quiz['title'] ?? 'No Title'),
                    subtitle: Text(
                      quiz['deadline'] != null
                          ? 'Deadline: ${quiz['deadline']}'
                          : 'No Deadline',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit quiz page
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
          // Navigate to add quiz page
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
