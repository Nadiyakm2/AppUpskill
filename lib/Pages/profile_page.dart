import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Info
              Row(
                children: [
                  // Profile Picture (Default Icon if no image)
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300], // Light grey background
                    child: const Icon(Icons.person, size: 40, color: Colors.grey), // Default user icon
                  ),
                  const SizedBox(width: 16),
                  // Name & Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Hanna Imbichi", // Replace with user's name
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "hanna@example.com", // Replace with user's email
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // User Statistics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Courses", "12"),
                  _buildStatCard("Achievements", "5"),
                  _buildStatCard("Quizzes", "30"),
                ],
              ),
              const SizedBox(height: 20),

              // Courses Section
              const Text(
                "Your Courses",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              _buildCourseCard("Flutter Development", "Completed", Colors.green),
              _buildCourseCard("Python for Data Science", "In Progress", Colors.orange),
              _buildCourseCard("UI/UX Fundamentals", "Completed", Colors.green),
              _buildCourseCard("Machine Learning", "In Progress", Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for User Statistics
  Widget _buildStatCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Course List
  Widget _buildCourseCard(String courseTitle, String status, Color statusColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.school, size: 40, color: Colors.blueAccent),
        title: Text(courseTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
