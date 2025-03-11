import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Fetch user data
  Future<List<Map<String, dynamic>>> fetchUserData() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await supabase
          .from('users') // Table name 'users' (lowercase)
          .select('*') // Selecting all columns (or specify if needed)
          .eq('user_id', userId); // Matching user_id to the logged-in user's ID

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching user data: $e");
      rethrow;
    }
  }

  // Fetch user role
  Future<String?> fetchUserRole() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await supabase
          .from('users') // Table name 'users'
          .select('role') // Selecting 'role' column
          .eq('user_id', userId) // Querying by 'user_id'
          .single(); // Expecting only one result

      return response['role']; // Returning role directly from the response
    } catch (e) {
      print("Error fetching user role: $e");
      return null; // Return null if error occurs (or handle as you prefer)
    }
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }
}
