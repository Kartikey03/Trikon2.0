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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Hackathon Hub',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF6BEBFB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Stepper indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                for (int i = 0; i < _roundsData.length; i++) ...[
                  _buildStepCircle(i),
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
          const SizedBox(height: 30),
          // Round content
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  currentRound.icon,
                                  size: 36,
                                  color: currentRound.iconColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  currentRound.title,
                                  style: const TextStyle(
                                    fontSize: 24,
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            currentRound.description,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(16),
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
                                    Icon(
                                      Icons.bookmark,
                                      color: const Color(0xFF6C63FF),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Evaluation Criteria",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF6C63FF),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  children: currentRound.evaluationCriteria.map((criteria) {
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "•",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF6C63FF),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            criteria,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
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
          const SizedBox(height: 16),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentStep > 0 ? () => _goToStep(_currentStep - 1) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      const SizedBox(width: 8),
                      Text("Previous"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _currentStep < _roundsData.length - 1 ? () => _goToStep(_currentStep + 1) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text("Next"),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step) {
    final bool isActive = step == _currentStep;
    final bool isCompleted = step < _currentStep;

    return GestureDetector(
      onTap: () => _goToStep(step),
      child: Container(
        width: 40,
        height: 40,
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive || isCompleted ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
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