import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  // 🔹 Sign up with email, password, name, and role
  Future<void> signUpWithEmailPassword(String email, String password, String name, String role) async {
    try {
      // Validate role
      const allowedRoles = {'admin', 'teacher', 'alumni', 'student'};
      if (!allowedRoles.contains(role)) {
        throw Exception('Invalid role: $role');
      }

      // Step 1: Sign up with Supabase Auth
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('User registration failed');
      }

      print("📌 Waiting for email confirmation...");

      // Step 2: Save user profile to the `user_profiles` table
      await supabase.from('user_profiles').upsert({
        'user_id': user.id, // Link to the authenticated user
        'email': email,
        'name': name,
        'role': role,
        'created_at': DateTime.now().toIso8601String(),
      });

      print("✅ User registered successfully with name: $name and role: $role");
    } catch (e) {
      print("🚨 Sign-up error: ${e.toString()}");
      rethrow;
    }
  }

  // 🔹 Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Login failed');
      }

      print("✅ User logged in successfully!");
      return user;
    } catch (e) {
      print("🚨 Sign-in error: ${e.toString()}");
      rethrow;
    }
  }

  // 🔹 Fetch user role after login
  Future<String?> getUserRole() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      // Fetch role from `user_profiles` table
      final response = await supabase
          .from('user_profiles')
          .select('role')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        print("🚨 No role found in `user_profiles` table!");
        return null;
      }

      final String role = response['role'];
      print("✅ User role: $role");
      return role;
    } catch (e) {
      print("🚨 Error fetching user role: ${e.toString()}");
      return null;
    }
  }

  // 🔹 Fetch user's name
  Future<String?> getUserName() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return null;

      // Fetch name from `user_profiles` table
      final response = await supabase
          .from('user_profiles')
          .select('name')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        print("🚨 No name found in `user_profiles` table!");
        return null;
      }

      final String name = response['name'];
      print("✅ User name: $name");
      return name;
    } catch (e) {
      print("🚨 Error fetching user name: ${e.toString()}");
      return null;
    }
  }

  // 🔹 Reset password
  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      print("✅ Password reset email sent.");
    } catch (e) {
      print("🚨 Password reset error: ${e.toString()}");
      rethrow;
    }
  }

  // 🔹 Logout
  Future<void> logOut() async {
    try {
      await supabase.auth.signOut();
      print("✅ User logged out successfully.");
    } catch (e) {
      print("🚨 Logout error: ${e.toString()}");
      rethrow;
    }
  }

  // 🔹 Debugging helper to check user session
  void debugSession() {
    final session = supabase.auth.currentSession;
    print("🔎 Current Session: $session");

    final user = supabase.auth.currentUser;
    print("🔎 Current User: $user");

    if (user != null) {
      print("🔎 User Email: ${user.email}");
      print("🔎 User ID: ${user.id}");
    }
  }
}