import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlumniScreen extends StatefulWidget {
  @override
  _AlumniScreenState createState() => _AlumniScreenState();
}

class _AlumniScreenState extends State<AlumniScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> alumniList = [];

 @override
void initState() {
  super.initState();
  fetchAlumni(); // Runs only once, avoiding infinite loop
}

Future<void> fetchAlumni() async {
  final response = await supabase.from('alumni').select('*');
  if (mounted) {
    setState(() {
      alumniList = response.map((e) => e as Map<String, dynamic>).toList();
    });
  }
}


  Future<void> connectWithAlumni(int alumniId) async {
    final studentId = supabase.auth.currentUser?.id;
    if (studentId == null) return;

    await supabase.from('alumni').update({
      'connected_students': Supabase.instance.client.rpc("array_append", params: {
        "column_name": "connected_students",
        "value": studentId
      })
    }).eq('id', alumniId);

    await supabase.from('students').update({
      'connections': Supabase.instance.client.rpc("array_append", params: {
        "column_name": "connections",
        "value": alumniId
      })
    }).eq('id', studentId);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connected successfully!")));
    fetchAlumni();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alumni Network")),
      body: alumniList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: alumniList.length,
              itemBuilder: (context, index) {
                final alumni = alumniList[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: alumni['profile_pic'] != null
                          ? NetworkImage(alumni['profile_pic'])
                          : AssetImage('assets/default_profile.png') as ImageProvider, // ✅ Default Image
                    ),
                    title: Text(alumni['name'] ?? 'Unknown'), // ✅ Prevent null issues
                    subtitle: Text(alumni['job'] ?? 'Not specified'), // ✅ Prevent null issues
                    trailing: ElevatedButton(
                      onPressed: () => connectWithAlumni(alumni['id']),
                      child: Text("Connect"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
