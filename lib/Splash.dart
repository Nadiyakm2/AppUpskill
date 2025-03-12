import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upskill_app/Onboarding/onboarding_screen.dart';
import 'package:upskill_app/app_users/teacher/teacher_home.dart';
import 'package:upskill_app/auth/login_page.dart';
import 'package:upskill_app/app_users/students/home/students_home.dart';
import 'package:upskill_app/app_users/admin/admin_home.dart';

import 'auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoTranslateAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for logo scaling, translation, and text fade
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    // Define scale animation for the logo
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Define translation animation for the logo
    _logoTranslateAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Define fade animation for the text
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Check login status after a delay
    Future.delayed(const Duration(seconds: 2), _checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final String userRole = prefs.getString('userRole') ?? ''; // Role data

      if (!mounted) return;

      // Navigate based on the login and onboarding status
      if (!hasSeenOnboarding) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AuthGate()),
        );
      } else if (isLoggedIn) {
        // Role-based navigation
        switch (userRole) {
          case 'student':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => StudentsHome()), // Student home
            );
            break;
          case 'teacher':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TeacherHome()), // Teacher home
            );
            break;
          case 'admin':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminHome()), // Admin home
            );
            break;
          default:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()), // If no role, go to login
            );
            break;
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()), // If not logged in, go to login
        );
      }
    } catch (e) {
      print("Error checking login status: $e");

      _showErrorSnackbar('Failed to load your session data. Please try again.');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()), // In case of error, show login
        );
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _checkLoginStatus,
        ),
      ),
    );
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
                Color.fromARGB(255, 174, 215, 249),
                Color.fromARGB(255, 176, 107, 251),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0.0, _logoTranslateAnimation.value),
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 163, 138, 209),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipOval(
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                      Color.fromARGB(255, 236, 219, 255),
                                      BlendMode.modulate, // Adds a soft overlay color
                                    ),
                                    child: Image.asset(
                                      "assets/logo1.png",
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: const Text(
                    "Welcome to Upskill",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 25, 19, 30),
                      letterSpacing: 1.8,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 107, 128, 178),
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: const Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}