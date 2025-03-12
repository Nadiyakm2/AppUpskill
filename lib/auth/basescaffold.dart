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

  // Log out function
  void logout() async {
    await authService.signOut();  // Sign the user out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ensure this is set to false
      themeMode: widget.themeMode,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurpleAccent),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(backgroundColor: Color.fromARGB(255, 96, 72, 161)),
        scaffoldBackgroundColor: Color.fromARGB(221, 24, 16, 16),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        cardColor: Colors.black45,
        buttonTheme: ButtonThemeData(buttonColor: Colors.deepPurple),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.black54,
          hintStyle: TextStyle(color: Colors.white54),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: logout,  // Log out when the icon is pressed
              icon: const Icon(
                Icons.logout,
                color:  Color(0xffa88979),
              ),
            )
          ],
        ),
        body: widget.body,
      ),
    );
  }
}