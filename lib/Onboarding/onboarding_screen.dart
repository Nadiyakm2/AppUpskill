import 'package:flutter/material.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose(); // Prevent memory leaks
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: const [
              OnboardingPage(
                title: "Find the right skill for you",
                subtitle: "You've been thinking about it, now's the time to actually start!",
                image: "assets/image1.png",
              ),
              OnboardingPage(
                title: "Connect, collaborate, and conquer new skills as a team",
                subtitle: "Upskilling is more powerful when you do it with others!",
                image: "assets/image2.png",
              ),
              OnboardingPage(
                title: "Upskill at your own rhythm",
                subtitle: "Flexible learning for a busy life. Learn when you can, grow as you go!",
                image: "assets/image3.png",
              ),
            ],
          ),

          // Progress Indicator
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue.shade900 : Colors.grey.shade300,
                  ),
                );
              }),
            ),
          ),

          // Navigation Buttons
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == 2 ? "Get Started" : "Next",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentPage > 0)
                      TextButton(
                        onPressed: _previousPage,
                        child: Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 20),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/auth'),
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}