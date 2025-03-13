import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upskill_app/Onboarding/onboarding_screen.dart';
import 'package:upskill_app/app_users/teacher/teacher_home.dart';
import 'package:upskill_app/auth/login_page.dart';
import 'package:upskill_app/app_users/students/home/students_home.dart';
import 'package:upskill_app/app_users/admin/admin_home.dart';
import 'package:upskill_app/auth/roles.dart'; // Ensure this file exists for role selection

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _logoScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash animation delay

    if (!mounted) return; // Prevent navigation on unmounted state

    try {
      final prefs = await SharedPreferences.getInstance();
      final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final String? userRole = prefs.getString('userRole');

      Widget nextPage;

      if (!hasSeenOnboarding) {
        nextPage = OnboardingScreen(); // Show onboarding if not seen
      } else if (!isLoggedIn) {
        nextPage = const LoginPage(); // Show login if not logged in
      } else if (userRole == null || userRole.isEmpty) {
        nextPage = const Roles(); // Show role selection if no role is set
      } else {
        nextPage = _getUserHome(userRole); // Show user home if role exists
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => nextPage),
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  Widget _getUserHome(String role) {
    switch (role) {
      case 'student':
        return StudentsHome();
      case 'teacher':
        return const TeacherHome();
      case 'admin':
        return const AdminHome();
      default:
        return const LoginPage();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 160, 148, 255),
                Color.fromARGB(255, 215, 175, 240),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Image.asset(
                    "assets/logo1.png",
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: const Text(
                    "Welcome to Upskill",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
