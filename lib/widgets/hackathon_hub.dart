import 'package:flutter/material.dart';

class HackathonHubScreen extends StatefulWidget {
  const HackathonHubScreen({Key? key}) : super(key: key);

  @override
  State<HackathonHubScreen> createState() => _HackathonHubScreenState();
}

class _HackathonHubScreenState extends State<HackathonHubScreen> {
  int _currentStep = 0;

  final List<RoundData> _roundsData = [
    RoundData(
      index: 0,
      title: "Round 1: Vision Forge",
      icon: Icons.lightbulb,
      iconColor: Colors.amber,
      description: "Teams will pitch their ideas to a panel of mentors, integrating a given AI/ML-based challenge into their proposed solution. Only the top 20 teams will move forward, based on how effectively they blend innovation with the AI/ML component.",
      tagline: "20 teams will advance to the next round",
      evaluationCriteria: [
        "Relevance and clarity of the problem",
        "Creativity and feasibility of the solution",
        "Smart integration of the AI/ML challenge",
        "Structured approach and presentation",
      ],
    ),
    RoundData(
      index: 1,
      title: "Round 2: Build Blitz",
      icon: Icons.build,
      iconColor: Color(0xFFAA8F7C),
      description: "The selected 20 teams will now focus on developing a working prototype of their solution. Teams receive access to necessary tools and resources to build and test their model.",
      tagline: "Top 10 teams will qualify for the final round",
      evaluationCriteria: [
        "Technical competence in implementation",
        "Efficient and creative approach",
        "Functional and scalable prototype",
        "Responsive to mentor feedback",
      ],
    ),
    RoundData(
      index: 2,
      title: "Round 3: Pinnacle Pitch",
      icon: Icons.emoji_events,
      iconColor: Colors.amber,
      description: "The top 10 teams compete in the ultimate pitch battle, showcasing their solutions to judges, industry experts, and potential sponsors. Each team presents their prototype and explains its impact.",
      tagline: "Winners of TRIKON 2.0 will be crowned",
      evaluationCriteria: [
        "Polished technical execution",
        "Demonstrated real-world applicability",
        "Viable business model presentation",
        "Compelling presentation skills",
      ],
    ),
  ];

  void _goToStep(int step) {
    if (step >= 0 && step < _roundsData.length) {
      setState(() {
        _currentStep = step;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRound = _roundsData[_currentStep];

    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final EdgeInsets padding = MediaQuery.of(context).padding;

    // Responsive adjustments
    final bool isSmallScreen = width < 600;
    final double horizontalPadding = isSmallScreen ? 16 : 40;
    final double fontSize = isSmallScreen ? 24 : 28;
    final double iconSize = isSmallScreen ? 30 : 36;
    final double stepCircleSize = isSmallScreen ? 32 : 40;
    final double titleFontSize = isSmallScreen ? 20 : 24;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.only(
                  top: 16,
                  left: horizontalPadding,
                  right: horizontalPadding
              ),
              child: Column(
                children: [
                  Text(
                    'Hackathon Hub',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6BEBFB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Stepper indicator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  for (int i = 0; i < _roundsData.length; i++) ...[
                    _buildStepCircle(i, size: stepCircleSize),
                    if (i < _roundsData.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i < _currentStep ? const Color(0xFF6C63FF) : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Round content
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: horizontalPadding / 2,
                    vertical: 16
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6C63FF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: isSmallScreen ? 50 : 60,
                                  height: isSmallScreen ? 50 : 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    currentRound.icon,
                                    size: iconSize,
                                    color: currentRound.iconColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    currentRound.title,
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6C63FF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              currentRound.tagline,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              currentRound.description,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 15,
                                height: 1.5,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.bookmark,
                                        color: Color(0xFF6C63FF),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Evaluation Criteria",
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 16 : 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF6C63FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildEvaluationCriteria(
                                      context,
                                      currentRound.evaluationCriteria,
                                      isSmallScreen: isSmallScreen
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
              ),
            ),

            // Navigation buttons
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding / 2,
                  vertical: 8
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentStep > 0 ? () => _goToStep(_currentStep - 1) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 20,
                          vertical: isSmallScreen ? 10 : 12
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, size: isSmallScreen ? 14 : 16),
                        SizedBox(width: isSmallScreen ? 4 : 8),
                        Text(
                            "Previous",
                            style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14
                            )
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _currentStep < _roundsData.length - 1 ? () => _goToStep(_currentStep + 1) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 20,
                          vertical: isSmallScreen ? 10 : 12
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                            "Next",
                            style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14
                            )
                        ),
                        SizedBox(width: isSmallScreen ? 4 : 8),
                        Icon(Icons.arrow_forward, size: isSmallScreen ? 14 : 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCircle(int step, {required double size}) {
    final bool isActive = step == _currentStep;
    final bool isCompleted = step < _currentStep;

    return GestureDetector(
      onTap: () => _goToStep(step),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF6C63FF)
              : (isCompleted ? const Color(0xFF6C63FF).withOpacity(0.8) : Colors.grey.shade300),
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Center(
          child: Text(
            "${step + 1}",
            style: TextStyle(
              fontSize: size * 0.4,
              fontWeight: FontWeight.bold,
              color: isActive || isCompleted ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEvaluationCriteria(
      BuildContext context,
      List<String> criteria,
      {required bool isSmallScreen}
      ) {
    final width = MediaQuery.of(context).size.width;

    // For small screens, use a list view instead of a grid
    if (isSmallScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: criteria.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "•",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } else {
      // For larger screens, use a grid view
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: criteria.map((item) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "•",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      );
    }
  }
}

class RoundData {
  final int index;
  final String title;
  final IconData icon;
  final Color iconColor;
  final String description;
  final String tagline;
  final List<String> evaluationCriteria;

  RoundData({
    required this.index,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.description,
    required this.tagline,
    required this.evaluationCriteria,
  });
}