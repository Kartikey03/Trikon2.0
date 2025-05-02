import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/firebase_service.dart';

class JuryScreen extends StatefulWidget {
  const JuryScreen({super.key});

  @override
  State<JuryScreen> createState() => _JuryScreenState();
}

class _JuryScreenState extends State<JuryScreen> {
  final JuryService _juryService = JuryService();
  late Future<List<JuryModel>> _juryFuture;

  @override
  void initState() {
    super.initState();
    _juryFuture = _juryService.getJury();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jury'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: FutureBuilder<List<JuryModel>>(
          future: _juryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading jury: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No jury members available'));
            }

            final juryMembers = snapshot.data!;
            return _buildGridView(juryMembers, screenSize, isSmallScreen);
          },
        ),
      ),
    );
  }

  Widget _buildGridView(List<JuryModel> juryMembers, Size screenSize, bool isSmallScreen) {
    // Determine grid columns based on screen width
    int crossAxisCount = 2;
    if (screenSize.width > 900) {
      crossAxisCount = 4;
    } else if (screenSize.width > 600) {
      crossAxisCount = 3;
    } else if (screenSize.width < 400) {
      crossAxisCount = 1;
    }

    double padding = screenSize.width * 0.04; // 4% of screen width for padding
    padding = padding.clamp(8.0, 24.0); // Limit padding between 8 and 24

    return Padding(
      padding: EdgeInsets.all(padding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.7, // Adjusted for better proportions
          crossAxisSpacing: padding,
          mainAxisSpacing: padding,
        ),
        itemCount: juryMembers.length,
        itemBuilder: (context, index) {
          final jury = juryMembers[index];
          return GestureDetector(
            onTap: () => _showJuryDetails(jury),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      "assets/images/${jury.image}",
                      height: screenSize.height * 0.15, // Responsive height
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: screenSize.height * 0.15,
                        color: Colors.grey[300],
                        child: Icon(Icons.person, size: screenSize.width * 0.08),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jury.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              jury.role,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10 : 12,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => _launchUrl(jury.linkedin),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.02,
                                vertical: screenSize.height * 0.005,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0077B5).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF0077B5).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.shopping_bag,
                                    size: isSmallScreen ? 12 : 14,
                                    color: const Color(0xFF0077B5),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'LinkedIn',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 9 : 10,
                                      color: const Color(0xFF0077B5),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showJuryDetails(JuryModel jury) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        // Get screen size again in case of orientation change
        final Size currentSize = MediaQuery.of(context).size;
        final double maxHeight = currentSize.height * 0.85;
        final double horizontalPadding = currentSize.width * 0.05;

        return Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle for dragging
              Container(
                width: currentSize.width * 0.1,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with image
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          "assets/images/${jury.image}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: currentSize.width * 0.15,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: currentSize.height * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jury.name,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: currentSize.height * 0.005),
                            Text(
                              jury.role,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: Colors.grey[700],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: currentSize.height * 0.03),
                            if (jury.bio != null && jury.bio!.isNotEmpty) ...[
                              Text(
                                'About',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: currentSize.height * 0.01),
                              Text(
                                jury.bio!,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Colors.grey[800],
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: currentSize.height * 0.03),
                            ],
                            Text(
                              'Connect',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: currentSize.height * 0.02),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildConnectButton(
                                    icon: Icons.shopping_bag,
                                    color: const Color(0xFF0077B5),
                                    label: 'LinkedIn',
                                    onTap: () => _launchUrl(jury.linkedin),
                                    screenSize: currentSize,
                                  ),
                                  SizedBox(width: currentSize.width * 0.04),
                                  if (jury.email != null) ...[
                                    _buildConnectButton(
                                      icon: Icons.mail,
                                      color: const Color(0xFFE1306C),
                                      label: 'Email',
                                      onTap: () => _launchUrl('mailto:${jury.email}'),
                                      screenSize: currentSize,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    required Size screenSize,
  }) {
    final bool isSmallScreen = screenSize.width < 600;
    final double buttonWidth = isSmallScreen ? screenSize.width * 0.25 : 120.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: buttonWidth,
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: isSmallScreen ? 20 : 24),
            SizedBox(height: screenSize.height * 0.01),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}