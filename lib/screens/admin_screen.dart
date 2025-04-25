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
    const IntegratedM2MScreen(), // Add the M2M screen here
    const AuthWrapper(),
    const MealTrackerHome(),
  ];

  // For welcome animation
  bool _showadminWelcome = true;

  @override
  void initState() {
    super.initState();
    // Hide welcome message after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showadminWelcome = false;
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
    return Scaffold(
      drawer: MyDrawer(), // Add the drawer here
      body: Stack(
        children: [
          // Main content
          _adminScreens[_selectedIndex],

          // Welcome overlay (only shown initially)
          if (_showadminWelcome)
            AnimatedOpacity(
              opacity: _showadminWelcome ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: Colors.black.withOpacity(0.85),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
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
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome to TRIKON 2025!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The Ultimate Hackathon Experience',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Innovation • Collaboration • Excellence',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      appBar: AppBar(
        title: const Text(
          "TRIKON 2.0",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
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
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
                activeIcon: Icon(Icons.home_rounded, size: 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Location',
                activeIcon: Icon(Icons.location_on, size: 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
                activeIcon: Icon(Icons.person, size: 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timelapse),
                label: 'M2M',
                activeIcon: Icon(Icons.timelapse, size: 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code),
                label: 'QR Code',
                activeIcon: Icon(Icons.qr_code, size: 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner),
                label: 'Scan QR',
                activeIcon: Icon(Icons.qr_code_scanner, size: 28),
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
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/trix.jpg'), // Path to your Trix avatar image
          radius: 28,
        ),
      )
          : null,
    );
  }
}