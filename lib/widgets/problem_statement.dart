import 'package:flutter/material.dart';
import 'dart:async';

class ProblemStatementWidget extends StatefulWidget {
  const ProblemStatementWidget({Key? key}) : super(key: key);

  @override
  State<ProblemStatementWidget> createState() => _ProblemStatementWidgetState();
}

class _ProblemStatementWidgetState extends State<ProblemStatementWidget> with SingleTickerProviderStateMixin {
  final PageController _softwareController = PageController();
  final PageController _hardwareController = PageController();
  int _currentSoftwareIndex = 0;
  int _currentHardwareIndex = 0;
  Timer? _softwareTimer;
  Timer? _hardwareTimer;
  late TabController _tabController;

  // Software problem statements data
  final List<ProblemCategory> _softwareCategories = [
    ProblemCategory(
        title: "E-Governance",
        description: "Digital solutions for government services",
        icon: Icons.account_balance,
        color: Colors.blue,
        problems: [
          "Unified Citizen Portal",
          "Digital Identity Management",
          "Paperless Documentation System",
          "Public Service Delivery Tracker"
        ]
    ),
    ProblemCategory(
        title: "Open Innovation",
        description: "Collaborative development projects",
        icon: Icons.hub,
        color: Colors.green,
        problems: [
          "Community Code Repository",
          "Cross-Platform Solutions",
          "API Integration Framework",
          "Open Source Collaboration Tools"
        ]
    ),
  ];

  // Hardware problem statements data
  final List<ProblemCategory> _hardwareCategories = [
    ProblemCategory(
        title: "E-Governance",
        description: "Physical infrastructure for government",
        icon: Icons.business,
        color: Colors.orange,
        problems: [
          "IoT-based Public Monitoring",
          "Smart City Infrastructure",
          "Energy Efficient Government Buildings",
          "Accessible Hardware Interfaces"
        ]
    ),
    ProblemCategory(
        title: "Open Innovation",
        description: "Community-driven hardware designs",
        icon: Icons.memory,
        color: Colors.purple,
        problems: [
          "Open Hardware Platforms",
          "DIY Electronics for Education",
          "Modular Computing Solutions",
          "Low-Cost Medical Devices"
        ]
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _startAutoScroll();
  }

  void _handleTabChange() {
    // Reset timers when tab changes to avoid scroll conflicts
    if (_tabController.indexIsChanging) {
      _resetTimers();
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    // Only start timers for the active tab
    if (_tabController.index == 0) {
      _softwareTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_currentSoftwareIndex < _softwareCategories.length - 1) {
          _softwareController.animateToPage(
            _currentSoftwareIndex + 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _softwareController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    } else {
      _hardwareTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
        if (_currentHardwareIndex < _hardwareCategories.length - 1) {
          _hardwareController.animateToPage(
            _currentHardwareIndex + 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _hardwareController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _resetTimers() {
    _softwareTimer?.cancel();
    _hardwareTimer?.cancel();
    _softwareTimer = null;
    _hardwareTimer = null;
  }

  @override
  void dispose() {
    _resetTimers();
    _softwareController.dispose();
    _hardwareController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with icon and title
                  _buildHeader(),
                  const SizedBox(height: 20),

                  // Tab Controller for Software and Hardware
                  _buildTabBar(),
                  const SizedBox(height: 20),

                  // Tab content - Software & Hardware with flexible sizing
                  Flexible(
                    fit: FlexFit.loose,
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(), // Prevents swipe to change tab
                      children: [
                        // Software Tab Content
                        _buildSoftwareContent(constraints),

                        // Hardware Tab Content
                        _buildHardwareContent(constraints),
                      ],
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFF10B981),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Problem Statements',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Explore these innovative challenges and pick what interests you most.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF3B82F6),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade700,
        tabs: const [
          Tab(
            icon: Icon(Icons.code),
            text: 'Software',
          ),
          Tab(
            icon: Icon(Icons.devices),
            text: 'Hardware',
          ),
        ],
      ),
    );
  }

  Widget _buildSoftwareContent(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PageView with constraints-based height
        SizedBox(
          height: constraints.maxHeight - 150, // Adjust based on other elements
          child: PageView.builder(
            controller: _softwareController,
            onPageChanged: (int page) {
              setState(() {
                _currentSoftwareIndex = page;
              });
            },
            itemCount: _softwareCategories.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(_softwareCategories[index]);
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page indicators
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _softwareCategories.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentSoftwareIndex == index ? 24.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentSoftwareIndex == index
                      ? const Color(0xFF3B82F6)
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHardwareContent(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PageView with constraints-based height
        SizedBox(
          height: constraints.maxHeight - 150, // Adjust based on other elements
          child: PageView.builder(
            controller: _hardwareController,
            onPageChanged: (int page) {
              setState(() {
                _currentHardwareIndex = page;
              });
            },
            itemCount: _hardwareCategories.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(_hardwareCategories[index]);
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page indicators
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _hardwareCategories.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentHardwareIndex == index ? 24.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentHardwareIndex == index
                      ? const Color(0xFF3B82F6)
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(ProblemCategory category) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  category.color,
                  category.color.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: Icon(
                    category.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Problem list with proper constraints
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Challenge Areas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: category.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Use Expanded for ListView
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: category.problems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: category.color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_right,
                                  color: category.color,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  category.problems[index],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF334155),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProblemCategory {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> problems;

  ProblemCategory({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.problems,
  });
}