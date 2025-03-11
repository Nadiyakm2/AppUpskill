import 'package:flutter/material.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/login_page.dart';

class BaseScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ensure this is set to false
      themeMode: themeMode,
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
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthService().logOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
            if (actions != null) ...actions!,
          ],
        ),
        body: body,
      ),
    );
  }
}