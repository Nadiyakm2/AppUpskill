import 'package:flutter/material.dart';
import 'package:upskill_app/Utils/app_routes.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final String difficulty;

  CategoryCard({required this.category, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.mcqScreen, arguments: {'category': category, 'difficulty': difficulty});
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(category, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
