import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upskill_app/app_users/alumni/job/job_post.dart';
import 'package:upskill_app/app_users/alumni/mentorship.dart';
import 'package:upskill_app/app_users/alumni/chatpage.dart';
import 'package:upskill_app/app_users/alumni/connections.dart';
import 'package:upskill_app/app_users/alumni/profiles.dart';
import 'package:upskill_app/app_users/students/leaderboard.dart';
import 'package:upskill_app/auth/basescaffold.dart';
import 'package:upskill_app/auth/profile_and_settings.dart';

class AlumniHome extends StatefulWidget {
  @override
  _AlumniHomeState createState() => _AlumniHomeState();
}

class _AlumniHomeState extends State<AlumniHome> {
  int _selectedIndex = 0;
  String? _userName;
  bool _isLoading = true;
  ThemeMode _themeMode = ThemeMode.light;

  // Page Widgets
  Widget chatPage = ChatPage();
  Widget profilePage = AlumniProfileScreen();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch user data (e.g., from Supabase)
  Future<void> fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.userMetadata?['name'] ?? 'User';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _userName = 'User';
      });
    }
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Welcome back, ${_userName ?? "User"}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            SliverToBoxAdapter(child: _buildSectionHeader('Quick Actions')),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 24),
              sliver: SliverToBoxAdapter(child: _buildQuickActionsGrid()),
            ),
            SliverToBoxAdapter(child: _buildSectionHeader('Recent Activity')),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 24),
              sliver: SliverToBoxAdapter(child: _buildRecentActivity()),
            ),
            SliverToBoxAdapter(child: _buildSectionHeader('Leaderboard')),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 32),
              sliver: SliverToBoxAdapter(child: _buildLeaderboardPreview()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 0.5,
            ),
          ),
          Spacer(),
          Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      padding: EdgeInsets.only(bottom: 8),
      children: [
        _buildFeatureCard(
          'Post Job',
          'Share opportunities',
          Icons.work_rounded,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobPostPage())),
        ),
        _buildFeatureCard(
          'Mentorship',
          'Guide students',
          Icons.school_rounded,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => MentorshipPage())),
        ),
        _buildFeatureCard(
          'Connections',
          'Manage network',
          Icons.people_alt_rounded,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => Connectionpage())),
        ),
        _buildFeatureCard(
          'Leaderboard',
          'Top mentors',
          Icons.leaderboard_rounded,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => LeaderboardScreen())),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.person_add_alt_1_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
            ),
            title: Text('New connection request', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('John Doe • 2 hours ago',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
            trailing: Icon(Icons.more_vert_rounded, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          ),
          Divider(height: 0, indent: 72),
        ],
      ),
    );
  }

  Widget _buildLeaderboardPreview() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LeaderboardScreen())),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.emoji_events_rounded, size: 40, color: Colors.white),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top Mentors',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  SizedBox(height: 6),
                  Text('View ranking of most active alumni',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation Bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Alumni Home',
      themeMode: _themeMode,
      body: _selectedIndex == 0
          ? _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildHomePage()
          : _selectedIndex == 1
              ? chatPage
              : profilePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
