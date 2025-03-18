import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventAnnouncementPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchEvents() async {
    final response = await Supabase.instance.client
        .from('events')
        .select();

    return response as List<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events & Announcements'),
        backgroundColor: Color(0xFFE6E6FA),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events available.'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  color: Color(0xFF87CEEB),
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(event['title'] ?? 'No Title'),
                    subtitle: Text(
                      event['date'] != null
                          ? 'Date: ${event['date']}'
                          : 'Date not available',
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
          // Navigate to add event page
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
