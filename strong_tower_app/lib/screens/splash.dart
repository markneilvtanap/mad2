import 'package:flutter/material.dart';
import 'package:strong_tower_app/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void start() {
    final nextPage = _pageController.page!.toInt() + 1;
    if (nextPage < 3) {
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: onPageChanged,
            scrollDirection: Axis.horizontal,
            children: [
              _buildPage(
                color: Colors.blue,
                image: 'assets/images/pic3.png',
                title: 'Quick Gym Access',
                description:
                    'Scan the QR code to easily log in and log out of the gym. No more manual check-ins; simply scan and start your workout!',
              ),
              _buildPage(
                color: Colors.purple,
                image: 'assets/images/pic1.png',
                title: 'Calorie Tracker',
                description:
                    'Keep track of your daily calorie intake effortlessly. Log your meals and monitor your nutrition to stay on top of your fitness goals.',
              ),
              _buildPage(
                color: Colors.red,
                image: 'assets/images/pic2.png',
                title: 'Activity History',
                description:
                    ' View your gym log-in/out history and calorie intake records. Stay informed about your workout sessions and dietary habits with detailed historical data.',
              ),
            ],
          ),
          Positioned(
            bottom: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircle(0),
                SizedBox(width: 8),
                _buildCircle(1),
                SizedBox(width: 8),
                _buildCircle(2),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
            width: screenWidth,
            child: ElevatedButton(
              onPressed: start,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(_currentPage < 2 ? 'Next' : 'Get Started'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
      {required Color color,
      required String image,
      required String title,
      required String description}) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(int index) {
    final scaleFactor = _currentPage == index ? 1.2 : 1.0;
    return Container(
      width: 12 * scaleFactor,
      height: 12 * scaleFactor,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.white : Colors.grey,
      ),
    );
  }
}
