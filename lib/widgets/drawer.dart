import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trikon2/screens/signinup_screen.dart';
import 'dart:io';
import '../screens/intellia_member_screen.dart';
import '../screens/aboutus_screen.dart';
import '../screens/feedback_screen.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName = "Loading...";
  String userEmail = "Loading...";
  String? profileImagePath;
  File? profileImageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Get current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Get email from Firebase Auth
      setState(() {
        userEmail = currentUser.email ?? "No email available";
      });

      // Fetch user name from Firebase Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("users").child(currentUser.uid);
      ref.child("name").get().then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            userName = snapshot.value.toString();
          });
        }
      });
    }

    // Fetch profile image path from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString("profile_image_${currentUser?.uid}");

    if (imagePath != null && imagePath.isNotEmpty) {
      // Check if file exists
      File file = File(imagePath);
      if (await file.exists()) {
        setState(() {
          profileImagePath = imagePath;
          profileImageFile = file;
        });
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  void _navigateToSocietyMembers() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SocietyMembersScreen()),
    );
  }

  void _navigateToAboutUs() {
    // Navigator.pop(context);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => AboutUsScreen()),
    // );
  }

  void _navigateToFeedbackForm() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackForm()),
    );
  }

  void _navigateToContactUs() {
    Navigator.pop(context);
    // Add navigation to Contact Us page
  }

  // Helper method for menu items that was missing
  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white.withOpacity(0.9), size: 26),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Color.lerp(Theme.of(context).primaryColor, Colors.white, 0.7) ?? Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // User profile section with modern design
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Column(
                children: [
                  // Profile image with border
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage: profileImageFile != null
                          ? FileImage(profileImageFile!)
                          : null,
                      child: profileImageFile == null
                          ? Icon(Icons.person, size: 50, color: Theme.of(context).primaryColor)
                          : null,
                    ),
                  ),
                  SizedBox(height: 15),
                  // Username with enhanced style
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 5),
                  // Email with subtle style
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Divider with enhanced style
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.white.withOpacity(0.5),
                thickness: 1,
              ),
            ),

            // Navigation items with improved styling
            _buildMenuItem(
              context,
              icon: Icons.groups_outlined,
              text: "Society Members",
              onTap: _navigateToSocietyMembers,
            ),

            _buildMenuItem(
              context,
              icon: Icons.info_outline_rounded,
              text: "About Us",
              onTap: _navigateToAboutUs,
            ),

            _buildMenuItem(
              context,
              icon: Icons.rate_review_outlined,
              text: "Feedback Form",
              onTap: _navigateToFeedbackForm,
            ),

            _buildMenuItem(
              context,
              icon: Icons.support_agent_outlined,
              text: "Contact Us",
              onTap: _navigateToContactUs,
            ),

            Spacer(), // Push the logout button to the bottom

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout, color: Theme.of(context).primaryColor),
                label: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}