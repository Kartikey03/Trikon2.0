import 'package:flutter/material.dart';
import 'package:trikon2/screens/profile_screen.dart';
import 'package:trikon2/screens/qr_scan.dart';
import 'package:trikon2/screens/qr_screen.dart';
import 'dashboard_screen.dart';
import 'location_screen.dart';
import 'm2m_screen.dart'; // Import the M2M (Minute to Minute) planner screen
import '../widgets/drawer.dart'; // Import the drawer widget
import 'chat_dialog.dart';

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
    const M2MScreen(),
    const ProfileScreen(),
    const AuthWrapper(), // Assuming this is what AuthWrapper was meant to be
    const MealTrackerHome(),
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

  void _openFeedbackScreen() {
    // Navigate to feedback screen (placeholder for now)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback screen will open here')),
    );
    // When implemented:
    // Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackScreen()));
  }

  void _openContactScreen() {
    // Navigate to contact screen (placeholder for now)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact screen will open here')),
    );
    // When implemented:
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen()));
  }

  void _openAboutScreen() {
    // Navigate to about screen (placeholder for now)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('About Us screen will open here')),
    );
    // When implemented:
    // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.feedback, color: Theme.of(context).primaryColor),
                title: const Text('Provide Feedback'),
                onTap: () {
                  Navigator.pop(context);
                  _openFeedbackScreen();
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_support, color: Theme.of(context).primaryColor),
                title: const Text('Contact Us'),
                onTap: () {
                  Navigator.pop(context);
                  _openContactScreen();
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: Theme.of(context).primaryColor),
                title: const Text('About Trikon 2.0'),
                onTap: () {
                  Navigator.pop(context);
                  _openAboutScreen();
                },
              ),
            ],
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(), // Add the drawer here
      body: Stack(
        children: [
          // Main content
          _mainScreens[_selectedIndex],

          // Welcome overlay (only shown initially)
          if (_showWelcome)
            AnimatedOpacity(
              opacity: _showWelcome ? 1.0 : 0.0,
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
                            "T2.0",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome to Trikon 2.0!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get ready for an amazing experience',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Experience innovation at its best',
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
      appBar: _selectedIndex == 0
          ? AppBar(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showMoreOptions,
          ),
        ],
      )
          : null,
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
                icon: Icon(Icons.schedule_outlined),
                label: 'M2M',
                activeIcon: Icon(Icons.schedule, size: 28),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
                activeIcon: Icon(Icons.person, size: 28),
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
          ? FloatingActionButton.extended(
        onPressed: _openChatDialog,
        label: const Text('Chat with Trix!'),
        icon: const Icon(Icons.chat, size: 28),
        elevation: 6,
      )
          : null,
    );
  }
}