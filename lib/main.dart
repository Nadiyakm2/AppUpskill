import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upskill_app/Onboarding/onboarding_screen.dart';
import 'package:upskill_app/app_users/admin/admin_home.dart';
import 'package:upskill_app/app_users/alumni/alumni_home.dart';
import 'package:upskill_app/app_users/students/home/students_home.dart';
import 'package:upskill_app/app_users/teacher/teacher_home.dart';
import 'package:upskill_app/auth/login_page.dart';
import 'package:upskill_app/Splash.dart';
import 'package:upskill_app/auth/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwZXJ5YmRqcmZrd3R5Y2N4bHplIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE2ODk3MzgsImV4cCI6MjA1NzI2NTczOH0.wOCIdDImi-w9jKkd8Yw8Osk-M4Brf6q4Df-h_Rrx0QM', // Replace with actual key
      url: 'https://sperybdjrfkwtyccxlze.supabase.co', // Replace with actual Supabase URL
    );
    print("✅ Supabase initialized successfully.");
  } catch (e) {
    print("❌ Supabase initialization failed: $e");
  }

  runApp(UpskillApp());
}

class UpskillApp extends StatelessWidget {
  UpskillApp({super.key});

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.root,
      routes: AppRoutes.routes,
    );
  }
}

class AppRoutes {
  static const String root = '/';
  static const String auth = '/auth';
  static const String studentHome = '/student_home';
  static const String teacherHome = '/teacher_home';
  static const String alumniHome = '/alumni_home';
  static const String adminHome = '/admin_home';
  static const String onboarding = '/onboarding';

  static Map<String, WidgetBuilder> get routes => {
        root: (context) => FutureBuilder<Widget>(
              future: _getStartupScreen(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                } else if (snapshot.hasError) {
                  return const LoginPage();
                } else {
                  return snapshot.data!;
                }
              },
            ),
        auth: (context) => const LoginPage(),
        studentHome: (context) => StudentsHome(),
        teacherHome: (context) => TeacherHome(),
        alumniHome: (context) => AlumniHome(),
        adminHome: (context) => AdminHome(),
        onboarding: (context) => OnboardingScreen(),
      };

  static Future<Widget> _getStartupScreen() async {
    await Future.delayed(Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    // ✅ Refresh session before checking user
    await Supabase.instance.client.auth.refreshSession();

    final session = Supabase.instance.client.auth.currentSession;
    final user = Supabase.instance.client.auth.currentUser;

    print("🔍 Checking user session...");
    print("➡️ Session: ${session?.toJson()}");
    print("➡️ User: ${user?.toJson()}");

    if (session != null && user != null) {
      String role = await _fetchUserRole(user.id);
      return hasSeenOnboarding ? _getHomeScreen(role) : OnboardingScreen();
    } else {
      return const LoginPage();
    }
  }

  static Future<String> _fetchUserRole(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();

      print("🎭 User Role: ${response['role']}");
      return response['role'] ?? 'student';
    } catch (error) {
      print("❌ Error fetching user role: $error");
      return 'student';
    }
  }

  static Widget _getHomeScreen(String role) {
    switch (role) {
      case 'student':
        return StudentsHome();
      case 'teacher':
        return TeacherHome();
      case 'alumni':
        return AlumniHome();
      case 'admin':
        return AdminHome();
      default:
        return StudentsHome();
    }
  }
}