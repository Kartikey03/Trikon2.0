import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

// Import our service
import '../services/firebase_service.dart';

class SocietyMembersScreen extends StatefulWidget {
  const SocietyMembersScreen({super.key});

  @override
  _SocietyMembersScreenState createState() => _SocietyMembersScreenState();
}

class _SocietyMembersScreenState extends State<SocietyMembersScreen> {
  final MembersService _membersService = MembersService();

  // Data holders
  List<MemberModel> _leadership = [];
  List<MemberModel> _coordinators = [];
  List<MemberModel> _coreTeam = [];
  List<MemberModel> _juniorTeam = [];

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final leadership = await _membersService.getLeadership();
      final coordinators = await _membersService.getStudentCoordinators();
      final coreTeam = await _membersService.getCoreTeam();
      final juniorTeam = await _membersService.getJuniorTeam();

      setState(() {
        _leadership = leadership;
        _coordinators = coordinators;
        _coreTeam = coreTeam;
        _juniorTeam = juniorTeam;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Society Members",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_errorMessage', style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: MediaQuery.of(context).size.height * 0.025,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leadership Section
              _buildSectionTitle(context, "President & Vice-President"),
              _buildLeadershipRow(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Coordinators Section
              _buildSectionTitle(context, "Student Coordinators"),
              _buildCoordinatorsRow(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Core Team Section
              _buildSectionTitle(context, "Core Team"),
              _buildCoreTeamGrid(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Junior Team Section
              if (_juniorTeam.isNotEmpty) ...[
                _buildSectionTitle(context, "Junior Team"),
                _buildJuniorTeamGrid(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final double titleSize = _getResponsiveFontSize(context, 22);

    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 3,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadershipRow(BuildContext context) {
    if (_leadership.isEmpty) {
      return Center(child: Text('No leadership data available'));
    }

    // Use LayoutBuilder to create responsive layouts
    return LayoutBuilder(
      builder: (context, constraints) {
        // For small screens, stack leaders vertically
        if (constraints.maxWidth < 600) {
          return Column(
            children: _leadership.map((leader) {
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: _buildMemberCard(
                    context,
                    member: leader,
                    isCompact: false,
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          // For larger screens, use row layout
          return Row(
            children: _leadership.map((leader) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: _buildMemberCard(
                    context,
                    member: leader,
                    isCompact: false,
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildCoordinatorsRow(BuildContext context) {
    if (_coordinators.isEmpty) {
      return Center(child: Text('No coordinator data available'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // For small screens, stack coordinators vertically
        if (constraints.maxWidth < 600) {
          return Column(
            children: _coordinators.map((coordinator) {
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: _buildMemberCard(
                    context,
                    member: coordinator,
                    isCompact: false,
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          // For larger screens, use row layout
          return Row(
            children: _coordinators.map((coordinator) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: _buildMemberCard(
                    context,
                    member: coordinator,
                    isCompact: false,
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildCoreTeamGrid(BuildContext context) {
    if (_coreTeam.isEmpty) {
      return Center(child: Text('No core team data available'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine column count based on screen width
        int crossAxisCount = _getResponsiveColumnCount(constraints.maxWidth);

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: _getResponsiveAspectRatio(context, crossAxisCount),
            crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
            mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
          ),
          itemCount: _coreTeam.length,
          itemBuilder: (context, index) {
            return _buildMemberCard(
              context,
              member: _coreTeam[index],
              isCompact: crossAxisCount > 2,
            );
          },
        );
      },
    );
  }

  Widget _buildJuniorTeamGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine column count based on screen width
        int crossAxisCount = _getResponsiveColumnCount(constraints.maxWidth);

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: _getResponsiveAspectRatio(context, crossAxisCount),
            crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
            mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
          ),
          itemCount: _juniorTeam.length,
          itemBuilder: (context, index) {
            return _buildMemberCard(
              context,
              member: _juniorTeam[index],
              isCompact: crossAxisCount > 2,
            );
          },
        );
      },
    );
  }

  Widget _buildMemberCard(
      BuildContext context, {
        required MemberModel member,
        bool isCompact = false,
      }) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double nameSize = _getResponsiveFontSize(context, isCompact ? 16 : 18);
    final double roleSize = _getResponsiveFontSize(context, isCompact ? 13 : 14);
    final double branchSize = _getResponsiveFontSize(context, 13);
    final double quoteSize = _getResponsiveFontSize(context, 12);

    // Calculate profile image size based on screen width
    final double imageSize = screenWidth < 600
        ? screenWidth * (isCompact ? 0.15 : 0.2)
        : (isCompact ? 80 : 100);

    final double padding = screenWidth * (isCompact ? 0.02 : 0.03);

    return Card(
      elevation: 5,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Theme.of(context).primaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile image with shadow
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/${member.image}',
                  fit: member.imagePosition == 'top' ? BoxFit.cover : BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: imageSize * 0.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (isCompact ? 0.01 : 0.015)),

            // Name
            Text(
              member.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: nameSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 4),

            // Role
            Text(
              member.role,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: roleSize,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            // Branch (only for non-compact cards)
            if (member.branch != null && !isCompact) ...[
              SizedBox(height: 4),
              Text(
                member.branch!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: branchSize,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ],

            // Quote (only for non-compact cards with quotes)
            if (member.quote != null && !isCompact) ...[
              SizedBox(height: 8),
              Text(
                '"${member.quote}"',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: quoteSize,
                  fontStyle: FontStyle.italic,
                  color: Colors.black38,
                ),
              ),
            ],

            SizedBox(height: MediaQuery.of(context).size.height * (isCompact ? 0.01 : 0.015)),

            // Social media icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(
                  context,
                  icon: Icons.email,
                  color: Colors.red,
                  url: "mailto:${member.gmail}",
                  isCompact: isCompact,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * (isCompact ? 0.02 : 0.03)),

                _buildSocialIcon(
                  context,
                  icon: Icons.photo_camera,
                  color: Colors.purple,
                  url: member.instagram,
                  isCompact: isCompact,
                ),

                SizedBox(width: MediaQuery.of(context).size.width * (isCompact ? 0.02 : 0.03)),

                _buildSocialIcon(
                  context,
                  icon: Icons.work,
                  color: Colors.blue,
                  url: member.linkedin,
                  isCompact: isCompact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String url,
        bool isCompact = false,
      }) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = screenWidth < 600 ? screenWidth * 0.04 : 20;
    final double padding = screenWidth * 0.018;

    return InkWell(
      onTap: () async {
        try {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not launch $url')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error launching $url: $e')),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: color,
        ),
      ),
    );
  }

  // Helper methods for responsive design

  // Get responsive font size based on screen width
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 360) {
      return baseSize * 0.8;
    } else if (screenWidth < 600) {
      return baseSize * 0.9;
    } else if (screenWidth < 900) {
      return baseSize;
    } else {
      return baseSize * 1.1;
    }
  }

  // Get responsive column count based on screen width
  int _getResponsiveColumnCount(double width) {
    if (width < 360) {
      return 1;  // Extra small screens
    } else if (width < 600) {
      return 2;  // Small screens
    } else if (width < 900) {
      return 3;  // Medium screens
    } else {
      return 4;  // Large screens
    }
  }

  // Get responsive aspect ratio for grid items
  double _getResponsiveAspectRatio(BuildContext context, int columnCount) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 360) {
      return 0.75;  // Taller cards on very small screens
    } else if (screenWidth < 600) {
      return 0.8;   // Taller cards on small screens
    } else if (columnCount == 3) {
      return 0.85;  // Medium screens
    } else {
      return 0.9;   // Wider cards on large screens
    }
  }
}