import 'package:flutter/material.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/login_page.dart';

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final ThemeMode themeMode;

  const BaseScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.themeMode = ThemeMode.light,
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  final authService = AuthService();
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
  }

  // Log out function
  void logout() async {
    await authService.signOut();  // Sign the user out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }

  // Theme toggle function
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ensure this is set to false
      themeMode: _themeMode,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
          iconTheme: IconThemeData(color: Colors.white),  // Ensuring the icons in AppBar are white
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),  // Primary text color in light mode
          titleLarge: TextStyle(color: Colors.black87),  // For app bar title
        ),
        iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
        buttonTheme: ButtonThemeData(buttonColor: Colors.deepPurpleAccent),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 81, 70, 115),
          iconTheme: IconThemeData(color: Colors.white),  // Ensure icons are white
        ),
        scaffoldBackgroundColor: Colors.black,  // Set the screen background to black in dark mode
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),  // White text color in dark mode
          titleLarge: TextStyle(color: Colors.white),  // For app bar title
        ),
        iconTheme: IconThemeData(color: Colors.white),
        cardColor: Colors.grey[800],  // Set the card background color to gray
        buttonTheme: ButtonThemeData(buttonColor: const Color.fromARGB(255, 56, 38, 88)),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color.fromARGB(136, 19, 141, 157),
          hintStyle: TextStyle(color: Colors.white54),  // Light gray hint color
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: _toggleTheme,  // Toggle theme when pressed
              icon: Icon(
                _themeMode == ThemeMode.light
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
                color: _themeMode == ThemeMode.light
                    ? const Color.fromARGB(255, 204, 202, 182)
                    : Colors.white,
              ),
            ),
            IconButton(
              onPressed: logout,  // Log out when the icon is pressed
              icon: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 201, 191, 186),  // Light brown logout icon color
              ),
            ),
          ],
        ),
        body: widget.body,
      ),
    );
  }
}
