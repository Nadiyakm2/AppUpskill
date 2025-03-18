import 'package:flutter/material.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/login_page.dart';

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final ThemeMode themeMode;
  final Widget? bottomNavigationBar; // Add bottomNavigationBar parameter

  const BaseScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.themeMode = ThemeMode.light,
    this.bottomNavigationBar, // Add bottomNavigationBar in constructor
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
    bool shouldLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // User does not want to log out
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // User confirmed to log out
            },
            child: Text('Log Out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await authService.signOut(); // Sign the user out
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
        (route) => false, // Remove all previous routes from the stack
      );
    }
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
          iconTheme: IconThemeData(color: Colors.white), // Ensuring the icons in AppBar are white
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: const Color.fromARGB(221, 224, 217, 217)), // Primary text color in light mode
          titleLarge: TextStyle(color: Colors.black87), // For app bar title
        ),
        iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
        buttonTheme: ButtonThemeData(buttonColor: Colors.deepPurpleAccent),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 81, 70, 115),
          iconTheme: IconThemeData(color: Colors.white), // Ensure icons are white
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 95, 88, 88), // Set the screen background to black in dark mode
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // White text color in dark mode
          titleLarge: TextStyle(color: Colors.white), // For app bar title
        ),
        iconTheme: IconThemeData(color: Colors.white),
        cardColor: const Color.fromARGB(255, 138, 132, 132), // Set the card background color to gray
        buttonTheme: ButtonThemeData(buttonColor: const Color.fromARGB(255, 56, 38, 88)),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color.fromARGB(135, 109, 133, 136),
          hintStyle: TextStyle(color: Colors.white54), // Light gray hint color
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: widget.actions ?? [
            IconButton(
              onPressed: _toggleTheme, // Toggle theme when pressed
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
              onPressed: logout, // Log out when the icon is pressed
              icon: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 201, 191, 186), // Light brown logout icon color
              ),
            ),
          ],
        ),
        body: widget.body,
        bottomNavigationBar: widget.bottomNavigationBar, // Pass the bottomNavigationBar to Scaffold
      ),
    );
  }
}
