import 'package:flutter/material.dart';
import 'package:upskill_app/auth/auth_service.dart';
import 'package:upskill_app/auth/login_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:upskill_app/main.dart'; // For carousel

class TeacherHome extends StatefulWidget {
  const TeacherHome({super.key});

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  final authService = AuthService();
  int _selectedIndex = 0; // For bottom navigation bar

  // Bottom navigation bar items
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'), // Placeholder for Home
    Text('Courses'), // Placeholder for Courses
    Text('Messages'), // Placeholder for Messages
    Text('Profile'), // Placeholder for Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Log out function
  void logout() async {
    await authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        backgroundColor: Color(0xFFE6E6FA), // Lavender color
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to notifications page
            },
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildFeatureCarousel(),
              const SizedBox(height: 20),
              _buildTwoColumnCards(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF8A2BE2), // Violet color
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open chatbot
          Navigator.pushNamed(context, AppRoutes.chatbot);
        },
        backgroundColor: Color(0xFF8A2BE2), // Violet color
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, size: 30, color: Colors.black),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Hello, Teacher!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search courses or students...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey.shade100, // Light grey background
      ),
    );
  }

  Widget _buildFeatureCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
      ),
      items: [
        _buildCarouselCard(
          "Student Achievements Highlight",
          "Showcase top-performing students with their recent certifications, skills earned, or placement updates.",
          "View More",
          Color(0xFFFFCCCB), // Light Coral
          Icons.emoji_events,
          () {
            // Navigate to Student Profiles
            Navigator.pushNamed(context, AppRoutes.studentProfiles);
          },
        ),
        _buildCarouselCard(
          "Performance Analytics Overview",
          "Total students engaged: 120\nCertifications verified: 45\nMost popular skill: Flutter",
          "View Insights",
          Color(0xFFADD8E6), // Light Blue
          Icons.analytics,
          () {
            // Navigate to Performance Analytics (if you have a dedicated page)
            print("Performance Analytics clicked");
          },
        ),
        _buildCarouselCard(
          "Course & Quiz Insights",
          "Most active course: SwiftUI\nPending quizzes: 3\nAssignments to grade: 5",
          "Manage Quizzes",
          Color(0xFF90EE90), // Light Green
          Icons.assignment,
          () {
            // Navigate to Quiz Management
            Navigator.pushNamed(context, AppRoutes.quizManagement);
          },
        ),
        _buildCarouselCard(
          "Upcoming Events & Deadlines",
          "Workshop: Flutter Basics\nDeadline: 25th March\nPlacement Drive: 30th March",
          "View Calendar",
          Color(0xFFFFD700), // Light Gold
          Icons.event,
          () {
            // Navigate to Event & Announcement
            Navigator.pushNamed(context, AppRoutes.eventAnnouncement);
          },
        ),
        _buildCarouselCard(
          "Pending Approvals & Verifications",
          "Certificates awaiting approval: 10\nPending course enrollments: 5",
          "Approve Now",
          Color(0xFFDDA0DD), // Plum
          Icons.approval,
          () {
            // Navigate to Certificate Verification
            Navigator.pushNamed(context, AppRoutes.certificateVerification);
          },
        ),
        _buildCarouselCard(
          "Placement Success Stories",
          "John Doe: Placed as Flutter Developer\nJane Smith: Hired as iOS Developer",
          "Read More",
          Color(0xFF87CEEB), // Sky Blue
          Icons.work,
          () {
            // Navigate to Placement & Alumni
            Navigator.pushNamed(context, AppRoutes.placementAlumni);
          },
        ),
      ],
    );
  }

  Widget _buildCarouselCard(String title, String description, String buttonText, Color color, IconData icon, VoidCallback onPressed) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 14, color: Colors.black54)),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8A2BE2), // Violet color
                  foregroundColor: Colors.white,
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoColumnCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dashboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildDashboardCard(
              "Overview of Student Activity",
              "Recent skill completions, certificates, and quiz participation.",
              Color(0xFFE6E6FA), // Lavender
              () {
                // Navigate to Student Profiles
                Navigator.pushNamed(context, AppRoutes.studentProfiles);
              },
            ),
            _buildDashboardCard(
              "Student Progress Tracking",
              "Monitor skills, certifications, and course progress.",
              Color(0xFFADD8E6), // Light Blue
              () {
                // Navigate to Student Profiles
                Navigator.pushNamed(context, AppRoutes.studentProfiles);
              },
            ),
            _buildDashboardCard(
              "Course & Quiz Management",
              "Create courses, assign quizzes, and set deadlines.",
              Color(0xFF90EE90), // Light Green
              () {
                // Navigate to Course Management
                Navigator.pushNamed(context, AppRoutes.courseManagement);
              },
            ),
            _buildDashboardCard(
              "Certificate Verification",
              "Approve or reject student-uploaded certificates.",
              Color(0xFFFFCCCB), // Light Coral
              () {
                // Navigate to Certificate Verification
                Navigator.pushNamed(context, AppRoutes.certificateVerification);
              },
            ),
            _buildDashboardCard(
              "Placement & Alumni Engagement",
              "Recommend students for placements and connect with alumni.",
              Color.fromARGB(255, 253, 232, 137), // Light Gold
              () {
                // Navigate to Placement & Alumni
                Navigator.pushNamed(context, AppRoutes.placementAlumni);
              },
            ),
            _buildDashboardCard(
              "Event & Announcement Section",
              "Create events, workshops, and share announcements.",
              Color(0xFFDDA0DD), // Plum
              () {
                // Navigate to Event & Announcement
                Navigator.pushNamed(context, AppRoutes.eventAnnouncement);
              },
            ),
            _buildDashboardCard(
              "Student Interaction & Support",
              "Provide mentorship and engage with students.",
              Color(0xFF87CEEB), // Sky Blue
              () {
                // Navigate to Chatbot
                Navigator.pushNamed(context, AppRoutes.chatbot);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardCard(String title, String description, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 8),
              Text(description, style: TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  // Show chatbot dialog
  void _showChatbot(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chatbot"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Hi! How can I assist you today?"),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () {
                // Send message logic
                print("Message sent");
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }
}