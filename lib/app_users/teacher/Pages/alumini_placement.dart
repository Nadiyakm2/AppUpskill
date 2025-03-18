import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlacementAlumniPage extends StatefulWidget {
  @override
  _PlacementAlumniPageState createState() => _PlacementAlumniPageState();
}

class _PlacementAlumniPageState extends State<PlacementAlumniPage> {
  Future<List<Map<String, dynamic>>> fetchPlacements() async {
    final response = await Supabase.instance.client.from('placements').select();

    return response as List<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placement & Alumni'),
        backgroundColor: Color(0xFFE6E6FA),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPlacements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No placement records available.'));
          } else {
            final placements = snapshot.data!;
            return ListView.builder(
              itemCount: placements.length,
              itemBuilder: (context, index) {
                final placement = placements[index];
                return Card(
                  color: Color(0xFFDDA0DD),
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(placement['company'] ?? 'Unknown Company',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Role: ${placement['role'] ?? 'Not Specified'}'),
                    trailing: Icon(Icons.business, color: Colors.deepPurple),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
