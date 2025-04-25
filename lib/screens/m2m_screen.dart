import 'package:flutter/material.dart';

class IntegratedM2MScreen extends StatefulWidget {
  const IntegratedM2MScreen({super.key});

  @override
  _IntegratedM2MScreenState createState() => _IntegratedM2MScreenState();
}

class _IntegratedM2MScreenState extends State<IntegratedM2MScreen> {
  // Define event schedule data structure for the Minute to Minute planner
  final List<Map<String, dynamic>> _scheduleItems = [
    {
      'startTime': '08:30 a.m.',
      'endTime': '10:00 a.m.',
      'activity': 'Welcoming (Entry)',
      'category': 'entry',
      'description': 'Registration and welcome kit distribution at the entrance',
    },
    {
      'startTime': '10:00 a.m.',
      'endTime': '10:30 a.m.',
      'activity': 'Welcome Speech and Inauguration',
      'category': 'ceremony',
      'description': 'Official event kickoff with welcome speeches from organizers',
    },
    {
      'startTime': '10:30 a.m.',
      'endTime': '11:00 a.m.',
      'activity': 'Event Explanation',
      'category': 'general',
      'description': 'Detailed explanation of hackathon rules, themes, and guidelines',
    },
    {
      'startTime': '11:00 a.m.',
      'endTime': '1:00 p.m.',
      'activity': 'Development and Mentoring Session 1',
      'category': 'development',
      'description': 'First major development session with mentor availability',
    },
    {
      'startTime': '1:00 p.m.',
      'endTime': '2:00 p.m.',
      'activity': 'Lunch',
      'category': 'meal',
      'description': 'Lunch break with networking opportunities',
    },
    {
      'startTime': '2:00 p.m.',
      'endTime': '4:00 p.m.',
      'activity': 'Development and Judging Session',
      'category': 'development',
      'description': 'Development continues with initial judge walkthrough',
    },
    {
      'startTime': '4:30 p.m.',
      'endTime': '5:00 p.m.',
      'activity': 'First Elimination',
      'category': 'elimination',
      'description': 'First round of eliminations based on initial progress',
    },
    {
      'startTime': '5:00 p.m.',
      'endTime': '6:30 p.m.',
      'activity': 'Interactive session 1 / Activity + Snacks',
      'category': 'interactive',
      'description': 'Team activities and networking while enjoying snacks',
    },
    {
      'startTime': '6:30 p.m.',
      'endTime': '8:00 p.m.',
      'activity': 'Development',
      'category': 'development',
      'description': 'Continued development with technical workshops available',
    },
    {
      'startTime': '8:00 p.m.',
      'endTime': '9:30 p.m.',
      'activity': 'Dinner',
      'category': 'meal',
      'description': 'Dinner break to recharge and network',
    },
    {
      'startTime': '9:30 p.m.',
      'endTime': '10:00 p.m.',
      'activity': 'Interactive Session 2 / Activity',
      'category': 'interactive',
      'description': 'Fun team activities to boost energy and creativity',
    },
    {
      'startTime': '10:00 p.m.',
      'endTime': '2:00 a.m.',
      'activity': 'Development and Mentoring Session 2',
      'category': 'development',
      'description': 'Late night development with specialized mentor support',
    },
    {
      'startTime': '2:00 a.m.',
      'endTime': '2:30 a.m.',
      'activity': 'Mid Night Snack',
      'category': 'meal',
      'description': 'Midnight refreshments to keep teams energized',
    },
    {
      'startTime': '2:30 a.m.',
      'endTime': '4:00 a.m.',
      'activity': 'Interactive session 3 / Activity',
      'category': 'interactive',
      'description': 'Engaging activities to maintain energy and focus',
    },
    {
      'startTime': '4:00 a.m.',
      'endTime': '6:00 a.m.',
      'activity': 'Development and Judging Session',
      'category': 'development',
      'description': 'Final development push with judge walkthroughs',
    },
    {
      'startTime': '8:00 a.m.',
      'endTime': '9:00 a.m.',
      'activity': 'Elimination + Breakfast',
      'category': 'elimination',
      'description': 'Second elimination round with breakfast provided',
    },
    {
      'startTime': '9:00 a.m.',
      'endTime': '10:00 a.m.',
      'activity': 'Final Development',
      'category': 'development',
      'description': 'Last-minute development and presentation preparation',
    },
    {
      'startTime': '10:30 a.m.',
      'endTime': '1:30 p.m.',
      'activity': 'Pitching',
      'category': 'presentation',
      'description': 'Teams present their final projects to judges',
    },
    {
      'startTime': '1:30 p.m.',
      'endTime': '2:00 p.m.',
      'activity': 'Felicitation Ceremony',
      'category': 'ceremony',
      'description': 'Closing ceremony with awards and recognition',
    },
  ];

  // Filter by category
  String? _selectedCategory;
  bool _showCurrentOnly = false;

  // Get the current event
  Map<String, dynamic>? _getCurrentEvent() {
    // This is a placeholder. In a real app, you would compare current time with event times
    // For demonstration, just return the first event
    return _scheduleItems.firstWhere(
          (item) => item['startTime'] == '10:00 a.m.',
      orElse: () => _scheduleItems[0],
    );
  }

  // Get color based on event category
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'entry':
        return Colors.grey.shade100;
      case 'ceremony':
        return const Color(0xFFFFD700).withOpacity(0.2); // Gold
      case 'general':
        return Colors.grey.shade100;
      case 'development':
        return const Color(0xFFFFF2CC); // Light yellow
      case 'meal':
        return const Color(0xFFF8CECC); // Light red/pink
      case 'interactive':
        return const Color(0xFFDAE8FC); // Light blue
      case 'elimination':
        return const Color(0xFFD5E8D4); // Light green
      case 'presentation':
        return const Color(0xFFE1D5E7); // Light purple
      default:
        return Colors.white;
    }
  }

  // Get icon based on event category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'entry':
        return Icons.login;
      case 'ceremony':
        return Icons.emoji_events;
      case 'general':
        return Icons.info_outline;
      case 'development':
        return Icons.code;
      case 'meal':
        return Icons.restaurant;
      case 'interactive':
        return Icons.people;
      case 'elimination':
        return Icons.filter_list;
      case 'presentation':
        return Icons.present_to_all;
      default:
        return Icons.event;
    }
  }

  // Get filtered schedule items
  List<Map<String, dynamic>> _getFilteredSchedule() {
    return _scheduleItems.where((item) {
      if (_selectedCategory != null && item['category'] != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSchedule = _getFilteredSchedule();
    final currentEvent = _getCurrentEvent();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Status bar space
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),

          // Current Event Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.8),
                      Theme.of(context).primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.access_time_filled,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "HAPPENING NOW",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${currentEvent?['startTime']} - ${currentEvent?['endTime'] ?? 'Ongoing'}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentEvent?['activity'] ?? "Loading...",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentEvent?['description'] ?? "Event details loading...",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          _getCategoryIcon(currentEvent?['category'] ?? 'general'),
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getCategoryName(currentEvent?['category'] ?? 'general'),
                          style: const TextStyle(
                            color: Colors. white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter options
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                const Text(
                  "Event Schedule",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                // Filter dropdown
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _selectedCategory,
                      icon: const Icon(Icons.filter_list, size: 18),
                      hint: const Text("All Events"),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 14,
                      ),
                      isDense: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text("All Events"),
                        ),
                        ...['entry', 'ceremony', 'general', 'development', 'meal', 'interactive', 'elimination', 'presentation']
                            .map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(_getCategoryName(category)),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Schedule List
          Expanded(
            child: filteredSchedule.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No events found",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredSchedule.length,
              itemBuilder: (context, index) {
                final item = filteredSchedule[index];
                final bool isCurrent = item == currentEvent;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Card(
                    elevation: isCurrent ? 2 : 1,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isCurrent
                          ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                          : BorderSide(color: Colors.grey.shade200),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // Show event details
                        _showEventDetails(context, item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getCategoryColor(item['category']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    _getCategoryIcon(item['category']),
                                    color: isCurrent ? Colors.white : _getIconColor(item['category']),
                                  ),
                                ),
                              ),
                              title: Text(
                                item['activity'],
                                style: TextStyle(
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "${item['startTime']} - ${item['endTime'] ?? 'Ongoing'}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            if (isCurrent)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "CURRENT EVENT",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Legend at bottom
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Dev', const Color(0xFFFFF2CC), Icons.code),
                _buildLegendItem('Food', const Color(0xFFF8CECC), Icons.restaurant),
                _buildLegendItem('Interactive', const Color(0xFFDAE8FC), Icons.people),
                _buildLegendItem('Elimination', const Color(0xFFD5E8D4), Icons.filter_list),
                _buildLegendItem('Presentation', const Color(0xFFE1D5E7), Icons.present_to_all),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getCategoryColor(event['category']),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(event['category']),
                          color: _getIconColor(event['category']),
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['activity'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getCategoryName(event['category']),
                                style: TextStyle(
                                  color: _getIconColor(event['category']),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${event['startTime']} - ${event['endTime'] ?? 'Ongoing'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Event description and details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About this event",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['description'] ?? "No additional details available for this event.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Event tips (hypothetical content)
                    if (event['category'] == 'development')
                      _buildTipSection(
                        "Development Tips",
                        "Make sure your code is well-documented and your project has a clear purpose. Be ready to explain your design decisions and technological choices.",
                        Icons.lightbulb_outline,
                      ),

                    if (event['category'] == 'presentation')
                      _buildTipSection(
                        "Presentation Tips",
                        "Focus on the problem you're solving and why your solution is innovative. Keep your pitch concise and highlight your unique value proposition.",
                        Icons.lightbulb_outline,
                      ),

                    if (event['category'] == 'meal')
                      _buildTipSection(
                        "Break Time",
                        "Take this opportunity to network with other participants and mentors. Stay hydrated and energized for the next phase of the hackathon.",
                        Icons.lightbulb_outline,
                      ),

                    const SizedBox(height: 16),

                    // Event location (hypothetical)
                    _buildInfoRow(
                      "Location",
                      event['category'] == 'meal' ? "Cafeteria - Ground Floor" :
                      event['category'] == 'presentation' ? "Main Auditorium" :
                      "Main Hall - First Floor",
                      Icons.location_on_outlined,
                    ),

                    const SizedBox(height: 12),

                    // Duration (calculated from startTime and endTime)
                    _buildInfoRow(
                      "Duration",
                      _calculateDuration(event['startTime'], event['endTime']),
                      Icons.timelapse,
                    ),

                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.notifications_active_outlined),
                          label: const Text("Set Reminder"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Reminder set for this event"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber.shade700),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _calculateDuration(String startTime, String? endTime) {
    if (endTime == null) {
      return "Ongoing";
    }

    // This is a simplified calculation - in a real app you would parse the times properly
    return "Approximately 2 hours";
  }

  Widget _buildLegendItem(String label, Color color, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Color _getIconColor(String category) {
    switch (category) {
      case 'development':
        return Colors.orange;
      case 'meal':
        return Colors.lightGreen;
      case 'interactive':
        return Colors.blue;
      case 'elimination':
        return Colors.red;
      case 'ceremony':
        return Colors.yellowAccent;
      case 'presentation':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'entry':
        return 'Entry';
      case 'ceremony':
        return 'Ceremony';
      case 'general':
        return 'General';
      case 'development':
        return 'Development';
      case 'meal':
        return 'Meal Break';
      case 'interactive':
        return 'Interactive';
      case 'elimination':
        return 'Elimination';
      case 'presentation':
        return 'Presentation';
      default:
        return category.substring(0, 1).toUpperCase() + category.substring(1);
    }
  }
}