import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> wishlist = [];

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    final studentId = supabase.auth.currentUser?.id;
    if (studentId == null) return;

    final response = await supabase
        .from('wishlist')
        .select('*')
        .eq('student_id', studentId);

    if (response is List) {
      setState(() {
        wishlist = response.map((e) => e as Map<String, dynamic>).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wishlist")),
      body: wishlist.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final course = wishlist[index];
                return ListTile(
                  title: Text(course['course_name'] ?? 'Unnamed Course'), // ✅ Prevent null issues
                );
              },
            ),
    );
  }
}
