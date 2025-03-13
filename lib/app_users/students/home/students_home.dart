import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upskill_app/app_users/students/Categories/coding/coding.dart';
import 'package:upskill_app/auth/basescaffold.dart';

import 'package:upskill_app/app_users/students/Categories/analytics.dart';
import 'package:upskill_app/app_users/students/Categories/designing.dart';
import 'package:upskill_app/app_users/students/Categories/marketing.dart';
import 'package:upskill_app/app_users/students/leaderboard.dart';
import 'package:upskill_app/app_users/students/notification.dart';
import 'package:upskill_app/auth/profile_and_settings.dart';

class StudentsHome extends StatefulWidget {
  @override
  _StudentsHomeState createState() => _StudentsHomeState();
}

class _StudentsHomeState extends State<StudentsHome> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoading = false;
  String? _userName = 'Loading...'; // Default name while fetching

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Function to fetch the logged-in user's name
  Future<void> _fetchUserName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('user_names') // Your table that holds user data
            .select('name') // Assuming there's a 'name' field in the 'user_names' table
            .eq('email', user?.email ?? '')
            .single();

        if (response != null) {
          setState(() {
            _userName = response['name'] ?? 'User'; // Set the user's name or default to 'User'
          });
        }
      } catch (e) {
        print("❌ Error fetching user name: $e");
        setState(() {
          _userName = 'Error fetching name';
        });
      }
    }
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Welcome, ${_userName ?? 'User'}', // Ensure non-null value is passed
      themeMode: _themeMode,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 30),
            _buildSectionTitle('Top Categories'),
            _buildCategoryRow(context),
            SizedBox(height: 30),
            _buildSectionTitle('Popular Courses'),
            _buildCourseList(),
            SizedBox(height: 30),
            _buildSectionTitle('Leaderboard'),
            GestureDetector(
              onTap: () => _navigateToScreen(LeaderboardScreen()),
              child: _buildLeaderboardCard(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white),
          onPressed: () => _navigateToScreen(NotificationsScreen()),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onSelected: _handleMenuAction,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'profile',
                child: Text('Profile & Settings'),
              ),
              PopupMenuItem(
                value: 'theme',
                child: Text(_themeMode == ThemeMode.light ? 'Dark Mode' : 'Light Mode'),
              ),
            ];
          },
        ),
      ],
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'profile':
        _navigateToScreen(ProfileAndSettingsScreen());
        break;
      case 'theme':
        _toggleTheme();
        break;
      default:
        break;
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: _themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
        letterSpacing: 0.5,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.purple.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start your learning journey now!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    await Future.delayed(Duration(seconds: 2)); // Simulate loading
                    setState(() => _isLoading = false);
                    // Navigate to the desired screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                    ),
                  )
                      : Text(
                    'Get Started',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.deepPurpleAccent),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Image.asset('assets/images/start.jpg', width: 80, height: 80, fit: BoxFit.cover),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(BuildContext context) {
    List<String> categories = ['Coding', 'Designing', 'Marketing', 'Analytics',];
    List<String> icons = [
      'assets/images/coding.png',
      'assets/images/designing.png',
      'assets/images/marketing.png',
      'assets/images/analytics.png'
    ];
    List<Widget> screens = [
      CodingScreen(),
      DesigningScreen(),
      MarketingScreen(),
      AnalyticsScreen(),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(categories.length, (index) {
        return GestureDetector(
          onTap: () => _navigateToScreen(screens[index]),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 136, 135, 163).withOpacity(0.1),
                ),
                padding: EdgeInsets.all(8),
                child: ClipOval(
                  child: Image.asset(
                    icons[index],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                categories[index],
                style: TextStyle(
                  fontSize: 14,
                  color: _themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCourseList() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCourseCard('Web Development', 'assets/images/web_development.png'),
          _buildCourseCard('UX Designing', 'assets/images/designing.png'),
        ],
      ),
    );
  }

  Widget _buildCourseCard(String title, String imagePath) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: _themeMode == ThemeMode.dark ? Colors.black45 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              imagePath,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.purple.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
      ),
      child: Row(
        children: [
          Image.asset('assets/images/violet.png', width: 80, height: 80, fit: BoxFit.cover),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              'Leaderboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
