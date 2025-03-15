import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:upskill_app/app_users/alumni/job_post.dart';
import 'package:upskill_app/app_users/alumni/mentorship.dart';
import 'package:upskill_app/app_users/alumni/connections.dart';
import 'package:upskill_app/app_users/students/leaderboard.dart';
import 'package:upskill_app/auth/basescaffold.dart';
import 'package:upskill_app/auth/profile_and_settings.dart';
import 'package:flutter/animation.dart';
class AlumniHome extends StatefulWidget {
  @override
  _AlumniHomeState createState() => _AlumniHomeState();
}

class _AlumniHomeState extends State<AlumniHome> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.titleLarge?.color, // Updated to titleLarge
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - _fadeAnimation.value)),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Theme.of(context).cardColor, // Adapts to theme
          child: Container(
            padding: EdgeInsets.all(20),
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1), // Adapts to theme
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32, color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color, // Updated to bodyLarge
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color, // Updated to bodyMedium
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor, // Updated to scaffoldBackgroundColor
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => Divider(height: 24),
        itemBuilder: (context, index) => ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1), // Adapts to theme
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_active, color: Theme.of(context).primaryColor),
          ),
          title: Text(
            'New connection request',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text('2 hours ago', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildLeaderboardPreview() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LeaderboardScreen())),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary], // Updated to colorScheme.secondary
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.emoji_events_rounded, size: 40, color: Colors.white),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Mentors',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'View ranking of most active alumni',
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Alumni Dashboard',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Quick Actions'),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFeatureCard(
                    'Post Opportunity',
                    'Share job/internship openings',
                    Icons.add_business_rounded,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobPostPage())),
                  ),
                  SizedBox(width: 16),
                  _buildFeatureCard(
                    'Mentorship',
                    'Guide students in your field',
                    Icons.school_rounded,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => MentorshipPage())),
                  ),
                  SizedBox(width: 16),
                  _buildFeatureCard(
                    'Connections',
                    'Manage your network',
                    Icons.people_alt_rounded,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConnectionPage())),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            _buildSectionHeader('Recent Activity'),
            _buildActivityList(),
            SizedBox(height: 32),
            _buildSectionHeader('Leaderboard'),
            _buildLeaderboardPreview(),
            // Add any more sections or widgets you need below
          ],
        ),
      ),
    );
  }
}
