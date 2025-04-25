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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leadership Section
              _buildSectionTitle(context, "President & Vice-President"),
              _buildLeadershipRow(context),
              SizedBox(height: 30),

              // Coordinators Section
              _buildSectionTitle(context, "Student Coordinators"),
              _buildCoordinatorsRow(context),
              SizedBox(height: 30),

              // Core Team Section
              _buildSectionTitle(context, "Core Team"),
              _buildCoreTeamGrid(context),
              SizedBox(height: 30),

              // Junior Team Section
              if (_juniorTeam.isNotEmpty) ...[
                _buildSectionTitle(context, "Junior Team"),
                _buildJuniorTeamGrid(context),
                SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 3,
            width: 100,
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

    return Row(
      children: _leadership.map((leader) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
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

  Widget _buildCoordinatorsRow(BuildContext context) {
    if (_coordinators.isEmpty) {
      return Center(child: Text('No coordinator data available'));
    }

    return Row(
      children: _coordinators.map((coordinator) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
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

  Widget _buildCoreTeamGrid(BuildContext context) {
    if (_coreTeam.isEmpty) {
      return Center(child: Text('No core team data available'));
    }

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: _coreTeam.length,
      itemBuilder: (context, index) {
        return _buildMemberCard(
          context,
          member: _coreTeam[index],
          isCompact: true,
        );
      },
    );
  }

  Widget _buildJuniorTeamGrid(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: _juniorTeam.length,
      itemBuilder: (context, index) {
        return _buildMemberCard(
          context,
          member: _juniorTeam[index],
          isCompact: true,
        );
      },
    );
  }

  Widget _buildMemberCard(
      BuildContext context, {
        required MemberModel member,
        bool isCompact = false,
      }) {
    return Card(
      elevation: 5,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(isCompact ? 12 : 16),
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
              width: isCompact ? 80 : 100,
              height: isCompact ? 80 : 100,
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
                        size: isCompact ? 40 : 50,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: isCompact ? 12 : 16),

            // Name
            Text(
              member.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isCompact ? 16 : 18,
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
                fontSize: isCompact ? 13 : 14,
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
                  fontSize: 13,
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
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.black38,
                ),
              ),
            ],

            SizedBox(height: isCompact ? 10 : 16),

            // Social media icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(
                  context,
                  icon: Icons.email,
                  color: Colors.red,
                  url: "mailto:${member.gmail}",
                ),
                SizedBox(width: isCompact ? 8 : 12),

                _buildSocialIcon(
                  context,
                  icon: Icons.photo_camera,
                  color: Colors.purple,
                  url: member.instagram,
                ),

                SizedBox(width: isCompact ? 8 : 12),

                _buildSocialIcon(
                  context,
                  icon: Icons.work,
                  color: Colors.blue,
                  url: member.linkedin,
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
      }) {
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
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: color,
        ),
      ),
    );
  }
}