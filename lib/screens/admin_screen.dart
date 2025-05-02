import 'package:flutter/material.dart';
import 'package:trikon2/screens/profile_screen.dart';
import 'package:trikon2/screens/qr_scan.dart';
import 'package:trikon2/screens/qr_screen.dart';
import 'package:trikon2/screens/m2m_screen.dart';
import 'package:trikon2/services/navigation_service.dart';
import 'dashboard_screen.dart';
import 'location_screen.dart';
import '../widgets/drawer.dart';
import 'chat_dialog.dart';
import '../widgets/event_timeline.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;
  final List<Widget> _adminScreens = [
    const DashboardScreen(),
    const LocationScreen(),
    const ProfileScreen(),
    const IntegratedM2MScreen(),
    const AuthWrapper(),
    const MealTrackerHome(),
  ];

  bool _showadminWelcome = true;

  @override
  void initState() {
    super.initState();
    // Set admin mode flag
    NavigationService.isAdminMode = true;

    // Hide welcome message after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showadminWelcome = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Reset admin mode flag when leaving this screen
    NavigationService.isAdminMode = false;
    super.dispose();
  }

  void _openChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => const ChatDialog(),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get device screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isSmallScreen = screenWidth < 600;

    // Get safe area paddings
    final EdgeInsets safePadding = MediaQuery.of(context).padding;

    return WillPopScope(
      onWillPop: () => NavigationService.handleBackPress(context),
      child: Scaffold(
        drawer: MyDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              _adminScreens[_selectedIndex],

              if (_showadminWelcome)
                AnimatedOpacity(
                  opacity: _showadminWelcome ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    color: Colors.black.withOpacity(0.85),
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: isSmallScreen ? 100 : 120,
                              height: isSmallScreen ? 100 : 120,
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
                                    fontSize: isSmallScreen ? 24 : 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            Text(
                              'Welcome to TRIKON 2025!',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 6 : 8),
                            Text(
                              'The Ultimate Hackathon Experience',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1, // Responsive margins
                              ),
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Innovation • Collaboration • Excellence',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
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
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            "TRIKON 2.0",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          // Add responsive padding to appbar
          toolbarHeight: kToolbarHeight + (isSmallScreen ? 0 : 8),
        ),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          // Add bottom safe area padding
          padding: EdgeInsets.only(bottom: safePadding.bottom),
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
              selectedFontSize: isSmallScreen ? 10 : 12,
              unselectedFontSize: isSmallScreen ? 9 : 10,
              iconSize: isSmallScreen ? 22 : 24,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                  activeIcon: Icon(Icons.home_rounded, size: isSmallScreen ? 24 : 28),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_outlined),
                  label: 'Location',
                  activeIcon: Icon(Icons.location_on, size: isSmallScreen ? 24 : 28),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                  activeIcon: Icon(Icons.person, size: isSmallScreen ? 24 : 28),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timelapse),
                  label: 'Schedule',
                  activeIcon: Icon(Icons.timelapse, size: isSmallScreen ? 24 : 28),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code),
                  label: 'QR Code',
                  activeIcon: Icon(Icons.qr_code, size: isSmallScreen ? 24 : 28),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_scanner),
                  label: 'Scan QR',
                  activeIcon: Icon(Icons.qr_code_scanner, size: isSmallScreen ? 24 : 28),
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
          // Make FAB responsive
          mini: isSmallScreen,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/trix.jpg'),
            radius: isSmallScreen ? 22 : 28,
          ),
        )
            : null,
      ),
    );
  }
}