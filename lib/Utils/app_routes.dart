import 'package:flutter/material.dart';
import 'package:upskill_app/app_users/students/mcq_screen.dart';
import 'package:upskill_app/app_users/students/leaderboard_screen.dart';

class AppRoutes {
  static const String mcqScreen = '/mcq';
  static const String leaderboardScreen = '/leaderboard';

  static Map<String, WidgetBuilder> routes = {
    mcqScreen: (context) => MCQScreen(category: 'coding', difficulty: 'Easy'),
    leaderboardScreen: (context) => LeaderboardScreen(),
  };
}
