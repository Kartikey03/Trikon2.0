import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocietyMembersScreen extends StatelessWidget {
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
      body: Container(
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, "President & Vice-President"),
              _buildLeadershipRow(context),
              SizedBox(height: 30),

              _buildSectionTitle(context, "Student Coordinators"),
              _buildCoordinatorsRow(context),
              SizedBox(height: 30),

              _buildSectionTitle(context, "Senior Team"),
              _buildSeniorTeamGrid(context),
              SizedBox(height: 40),
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
    return Row(
      children: [
        Expanded(
          child: _buildMemberCard(
            context,
            name: "Suvansh Jindal",
            role: "President",
            department: "CSE AIML",
            imagePath: "assets/images/suvansh.jpg",
            instagram: "suvanshhh__",  // Just username, not full URL
            linkedin: "suvansh-jindal-8687b3230",  // Just path, not full URL
            email: "suvansh@example.com",
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildMemberCard(
            context,
            name: "Utkarsh Garg",
            role: "Vice President",
            department: "CSE AI",
            imagePath: "assets/images/utkarsh.jpg",
            instagram: "utkarsh_garg",
            linkedin: "utkarsh-garg",
            email: "utkarsh@example.com",
          ),
        ),
      ],
    );
  }

  Widget _buildCoordinatorsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMemberCard(
            context,
            name: "Khushi Gupta",
            role: "Student Coordinator",
            department: "CSE AI",
            imagePath: "assets/images/khushi.jpg",
            instagram: "khushi_gupta",
            linkedin: "khushi-gupta",
            email: "khushi@example.com",
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildMemberCard(
            context,
            name: "Mayur Rastogi",
            role: "Student Coordinator",
            department: "CSE AIML",
            imagePath: "assets/images/mayur.jpg",
            instagram: "mayur_rastogi",
            linkedin: "mayur-rastogi",
            email: "mayur@example.com",
          ),
        ),
      ],
    );
  }

  Widget _buildSeniorTeamGrid(BuildContext context) {
    // Creating a list of senior team members
    List<Map<String, String>> seniorTeam = [
      {
        "name": "Aishwarya Jain",
        "role": "Content Head",
        "imagePath": "assets/images/aishwarya.jpg",
      },
      {
        "name": "Atharv Gupta",
        "role": "Social Media Head",
        "imagePath": "assets/images/atharv.jpg",
      },
      {
        "name": "Deepanshi Gautam",
        "role": "Web Development Head",
        "imagePath": "assets/images/deepanshi.jpg",
      },
      {
        "name": "Juwairia Parveen",
        "role": "PR Head",
        "imagePath": "assets/images/juwairia.jpg",
      },
      {
        "name": "Kartikey Sharma",
        "role": "App Development Head",
        "imagePath": "assets/images/kartikey.jpg",
      },
      {
        "name": "Kashish Sharma",
        "role": "Event Head",
        "imagePath": "assets/images/kashish.jpg",
      },
      {
        "name": "Mahi",
        "role": "Cultural Head",
        "imagePath": "assets/images/mahi.jpg",
      },
      {
        "name": "Parth Juneja",
        "role": "Automation Head",
        "imagePath": "assets/images/parth.jpg",
      },
      {
        "name": "Pradeum Gaur",
        "role": "Media Coverage Head",
        "imagePath": "assets/images/pradeum.jpg",
      },
      {
        "name": "Prayesi Agarwal",
        "role": "DS-Google Suite Head",
        "imagePath": "assets/images/prayesi.jpg",
      },
      {
        "name": "Shivendra Ojha",
        "role": "Operation Head",
        "imagePath": "assets/images/shivendra.jpg",
      },
      {
        "name": "Stuti Kumar",
        "role": "Quality Assurance Head",
        "imagePath": "assets/images/stuti.jpg",
      },
      {
        "name": "Vaishnavi Pathak",
        "role": "Designing Head",
        "imagePath": "assets/images/vaishnavi.jpg",
      },
      {
        "name": "Vanshika Vashisth",
        "role": "Creativity Head",
        "imagePath": "assets/images/vanshika.jpg",
      },
    ];

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: seniorTeam.length,
      itemBuilder: (context, index) {
        return _buildMemberCard(
          context,
          name: seniorTeam[index]["name"]!,
          role: seniorTeam[index]["role"]!,
          imagePath: seniorTeam[index]["imagePath"]!,
          instagram: seniorTeam[index]["name"]!.toLowerCase().replaceAll(" ", "_"),
          linkedin: seniorTeam[index]["name"]!.toLowerCase().replaceAll(" ", "-"),
          email: "${seniorTeam[index]["name"]!.split(" ")[0].toLowerCase()}@example.com",
          isCompact: true,
        );
      },
    );
  }

  Widget _buildMemberCard(
      BuildContext context, {
        required String name,
        required String role,
        String? department,
        required String imagePath,
        required String instagram,
        required String linkedin,
        required String email,
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
                  imagePath,
                  fit: BoxFit.cover,
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
              name,
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
              role,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isCompact ? 13 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            // Department (only for non-compact cards)
            if (department != null && !isCompact) ...[
              SizedBox(height: 4),
              Text(
                department,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
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
                  url: "mailto:$email",
                ),
                SizedBox(width: isCompact ? 12 : 16),
                _buildSocialIcon(
                  context,
                  icon: Icons.photo_camera,
                  color: Colors.purple,
                  url: "https://instagram.com/$instagram",
                ),
                SizedBox(width: isCompact ? 12 : 16),
                _buildSocialIcon(
                  context,
                  icon: Icons.work,
                  color: Colors.blue,
                  url: "https://linkedin.com/in/$linkedin",
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