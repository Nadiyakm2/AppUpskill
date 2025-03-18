import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upskill_app/Onboarding/onboarding_screen.dart';
import 'package:upskill_app/app_users/admin/admin_home.dart';
import 'package:upskill_app/app_users/alumni/alumni_home.dart';
import 'package:upskill_app/app_users/students/home/students_home.dart';
import 'package:upskill_app/app_users/teacher/Pages/Course_management.dart';
import 'package:upskill_app/app_users/teacher/Pages/alumini_placement.dart';
import 'package:upskill_app/app_users/teacher/Pages/certification_verification.dart';
import 'package:upskill_app/app_users/teacher/Pages/chatbot.dart';
import 'package:upskill_app/app_users/teacher/Pages/events_announcement.dart';
import 'package:upskill_app/app_users/teacher/Pages/quiz_mangement.dart';

import 'package:upskill_app/app_users/teacher/Pages/student_details.dart';
import 'package:upskill_app/app_users/teacher/teacher_home.dart';
import 'package:upskill_app/auth/login_page.dart';
import 'package:upskill_app/Splash.dart';
import 'package:upskill_app/auth/register_page.dart';

// Import Teacher Dashboard pages

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
  static const String studentHome = '/StudentsHome';
  static const String teacherHome = '/TeacherHome';
  static const String alumniHome = '/AluminiHome';
  static const String adminHome = '/AdminHome';
  static const String onboarding = '/onboarding';

  // Teacher Dashboard Routes
  static const String studentProfiles = '/student-profiles';
  static const String courseManagement = '/course-management';
  static const String quizManagement = '/quiz-management';
  static const String certificateVerification = '/certificate-verification';
  static const String placementAlumni = '/placement-alumni';
  static const String eventAnnouncement = '/event-announcement';
  static const String chatbot = '/chatbot';

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

    // Teacher Dashboard Routes
    studentProfiles: (context) => StudentProfilesPage(),
    courseManagement: (context) => CourseManagementPage(),
    quizManagement: (context) => QuizManagementPage(),
    certificateVerification: (context) => CertificateVerificationPage(),
    placementAlumni: (context) => PlacementAlumniPage(),
    eventAnnouncement: (context) => EventAnnouncementPage(),
    chatbot: (context) => ChatbotPage(),
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
      // Fetch user role and name based on email
      String role = await _fetchUserRole(user.email ?? '');
      return hasSeenOnboarding ? _getHomeScreen(role) : OnboardingScreen();
    } else {
      return const LoginPage();
    }
  }

  static Future<String> _fetchUserRole(String email) async {
    try {
      // Query the 'user_names' table to get the role and name based on the email
      final response = await Supabase.instance.client
          .from('user_names')
          .select('role, name')
          .eq('email', email)
          .single();

      print("🎭 User Role: ${response['role']}");
      print("📝 User Name: ${response['name']}");
      return response['role'] ?? 'student';  // Default to 'student' if no role is found
    } catch (error) {
      print("❌ Error fetching user role: $error");
      return 'student';  // Default to 'student' if error occurs
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