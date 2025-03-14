import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  int score = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, int>?;
    if (args != null) {
      score = args['score']!;
      _updateLeaderboard();
    }
  }

  Future<void> _updateLeaderboard() async {
    await supabase.from('leaderboard').insert({'user_id': 'user123', 'score': score});
  }

  Future<List<Map<String, dynamic>>> fetchLeaderboard() async {
    return await supabase.from('leaderboard').select().order('score', ascending: false).limit(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchLeaderboard(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final leaderboard = snapshot.data!;
          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(leaderboard[index]['user_id']),
                trailing: Text("${leaderboard[index]['score']} points"),
              );
            },
          );
        },
      ),
    );
  }
}
