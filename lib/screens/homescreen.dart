import 'package:flutter/material.dart';
import 'package:trikon2/screens/profile_screen.dart';
import 'package:trikon2/screens/qr_scan.dart';
import 'package:trikon2/screens/qr_screen.dart';
import 'package:trikon2/screens/m2m_screen.dart'; // Add this import for M2M screen
import 'dashboard_screen.dart';
import 'location_screen.dart';
import '../widgets/drawer.dart';
import 'chat_dialog.dart';
import '../widgets/event_timeline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _mainScreens = [
    const DashboardScreen(),
    const LocationScreen(),
    const ProfileScreen(),
    const IntegratedM2MScreen(), // Add the M2M screen here
    const AuthWrapper(),
  ];

  // For welcome animation
  bool _showWelcome = true;

  @override
  void initState() {
    super.initState();
    // Hide welcome message after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showWelcome = false;
        });
      }
    });
  }

  void _openChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => const ChatDialog(),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions using MediaQuery
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Get device padding to account for notches, status bars, etc.
    final devicePadding = MediaQuery.of(context).padding;

    // Adjust font sizes based on screen width
    final double titleFontSize = screenWidth < 360 ? 20 : 24;
    final double subtitleFontSize = screenWidth < 360 ? 14 : 16;
    final double welcomeHeaderSize = screenWidth < 360 ? 20 : 24;

    // Adjust logo size based on screen height
    final double logoSize = screenHeight < 600 ? 100 : 120;

    return Scaffold(
      drawer: MyDrawer(), // Add the drawer here
      body: Stack(
        children: [
          // Main content wrapped in SafeArea for proper padding
          SafeArea(
            child: _mainScreens[_selectedIndex],
          ),

          // Welcome overlay (only shown initially)
          if (_showWelcome)
            AnimatedOpacity(
              opacity: _showWelcome ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: Colors.black.withOpacity(0.85),
                width: double.infinity,
                height: double.infinity,
                // Use SafeArea here as well to respect device notches and system UI
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Intellia",
                                style: TextStyle(
                                  fontSize: screenWidth < 360 ? 28 : 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03), // Responsive spacing
                          Text(
                            'Welcome to TRIKON 2025!',
                            style: TextStyle(
                              fontSize: welcomeHeaderSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01), // Responsive spacing
                          Text(
                            'The Ultimate Hackathon Experience',
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02), // Responsive spacing
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Innovation • Collaboration • Excellence',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: subtitleFontSize + 2, // Slightly larger than subtitle
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          "TRIKON 2.0",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
            fontSize: screenWidth < 360 ? 18 : 20, // Responsive font size
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        // Make sure the AppBar has the proper top padding to avoid notches
        toolbarHeight: kToolbarHeight + (devicePadding.top > 0 ? 0 : 8),
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        // Ensure the navigation bar respects bottom system insets (e.g., home indicator on iPhones)
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom > 0 ? 0 : 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey.shade400,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            // Adjust item size based on screen width
            selectedFontSize: screenWidth < 360 ? 10 : 12,
            unselectedFontSize: screenWidth < 360 ? 8 : 10,
            iconSize: screenWidth < 360 ? 20 : 24,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
                activeIcon: Icon(Icons.home_rounded, size: screenWidth < 360 ? 24 : 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Location',
                activeIcon: Icon(Icons.location_on, size: screenWidth < 360 ? 24 : 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
                activeIcon: Icon(Icons.person, size: screenWidth < 360 ? 24 : 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timelapse),
                label: 'Schedule',
                activeIcon: Icon(Icons.timelapse, size: screenWidth < 360 ? 24 : 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code),
                label: 'QR Code',
                activeIcon: Icon(Icons.qr_code, size: screenWidth < 360 ? 24 : 28),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: _openChatDialog,
        elevation: 6,
        backgroundColor: Colors.transparent,
        shape: const CircleBorder(),
        // Adjust size based on screen dimensions
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/trix.jpg'), // Path to your Trix avatar image
          radius: screenWidth < 360 ? 24 : 28,
        ),
      )
          : null,
    );
  }
}