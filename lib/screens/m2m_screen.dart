import 'package:flutter/material.dart';

class M2MScreen extends StatefulWidget {
  const M2MScreen({super.key});

  @override
  _M2MScreenState createState() => _M2MScreenState();
}

class _M2MScreenState extends State<M2MScreen> {
  // Define event schedule data structure for the Minute to Minute planner
  final List<Map<String, dynamic>> _scheduleItems = [
    {
      'startTime': '08:30 a.m.',
      'endTime': '10:00 a.m.',
      'activity': 'Welcoming (Entry)',
      'category': 'entry',
    },
    {
      'startTime': '10:00 a.m.',
      'endTime': '10:30 a.m.',
      'activity': 'Welcome Speech and Inauguration',
      'category': 'ceremony',
    },
    {
      'startTime': '10:30 a.m.',
      'endTime': '11:00 a.m.',
      'activity': 'Event Explanation',
      'category': 'general',
    },
    {
      'startTime': '11:00 a.m.',
      'endTime': '1:00 p.m.',
      'activity': 'Development and Mentoring Session 1',
      'category': 'development',
    },
    {
      'startTime': '1:00 p.m.',
      'endTime': '2:00 p.m.',
      'activity': 'Lunch',
      'category': 'meal',
    },
    {
      'startTime': '2:00 p.m.',
      'endTime': '4:00 p.m.',
      'activity': 'Development and Judging Session',
      'category': 'development',
    },
    {
      'startTime': '4:30 p.m.',
      'endTime': null,
      'activity': 'First Elimination',
      'category': 'elimination',
    },
    {
      'startTime': '5:00 p.m.',
      'endTime': '6:30 p.m.',
      'activity': 'Interactive session 1 / Activity + Snacks',
      'category': 'interactive',
    },
    {
      'startTime': '6:30 p.m.',
      'endTime': '8:00 p.m.',
      'activity': 'Development',
      'category': 'development',
    },
    {
      'startTime': '8:00 p.m.',
      'endTime': '9:30 p.m.',
      'activity': 'Dinner',
      'category': 'meal',
    },
    {
      'startTime': '9:30 p.m.',
      'endTime': '10:00 p.m.',
      'activity': 'Interactive Session 2 / Activity',
      'category': 'interactive',
    },
    {
      'startTime': '10:00 p.m.',
      'endTime': '2:00 a.m.',
      'activity': 'Development and Mentoring Session 2',
      'category': 'development',
    },
    {
      'startTime': '2:00 a.m.',
      'endTime': '2:30 a.m.',
      'activity': 'Mid Night Snack',
      'category': 'meal',
    },
    {
      'startTime': '2:30 a.m.',
      'endTime': '4:00 a.m.',
      'activity': 'Interactive session 3 / Activity',
      'category': 'interactive',
    },
    {
      'startTime': '4:00 a.m.',
      'endTime': '6:00 a.m.',
      'activity': 'Development and Judging Session',
      'category': 'development',
    },
    {
      'startTime': '8:00 a.m.',
      'endTime': null,
      'activity': 'Elimination + Breakfast',
      'category': 'elimination',
    },
    {
      'startTime': '9:00 a.m.',
      'endTime': '10:00 a.m.',
      'activity': 'Final Development',
      'category': 'development',
    },
    {
      'startTime': '10:30 a.m.',
      'endTime': '1:30 p.m.',
      'activity': 'Pitching',
      'category': 'presentation',
    },
    {
      'startTime': '1:30 p.m.',
      'endTime': '2:00 p.m.',
      'activity': 'Felicitation Ceremony',
      'category': 'ceremony',
    },
  ];

  // Get color based on event category
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'entry':
        return Colors.white;
      case 'ceremony':
        return Colors.white;
      case 'general':
        return Colors.white;
      case 'development':
        return Color(0xFFFFF2CC); // Light yellow
      case 'meal':
        return Color(0xFFF8CECC); // Light red/pink
      case 'interactive':
        return Color(0xFFDAE8FC); // Light blue
      case 'elimination':
        return Color(0xFFD5E8D4); // Light green
      case 'presentation':
        return Color(0xFFE1D5E7); // Light purple
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Minute to Minute Planner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trikon 2.0 Schedule',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '24-Hour Hackathon Event Timeline',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Schedule List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: _scheduleItems.length,
              itemBuilder: (context, index) {
                final item = _scheduleItems[index];
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(item['category']),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            // Time column
                            Container(
                              width: 100,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item['startTime'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (item['endTime'] != null)
                                    Column(
                                      children: [
                                        SizedBox(height: 2),
                                        Text(
                                          'to',
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          item['endTime'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),

                            // Activity details
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getCategoryIcon(item['category']),
                                      color: _getIconColor(item['category']),
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item['activity'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: item['category'] == 'meal' ||
                                              item['category'] == 'elimination' ?
                                          FontWeight.bold : FontWeight.normal,
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
                    ),
                  ],
                );
              },
            ),
          ),

          // Legend
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Color Legend:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildLegendItem('Development', Color(0xFFFFF2CC)),
                    SizedBox(width: 12),
                    _buildLegendItem('Food', Color(0xFFF8CECC)),
                    SizedBox(width: 12),
                    _buildLegendItem('Interactive', Color(0xFFDAE8FC)),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    _buildLegendItem('Elimination', Color(0xFFD5E8D4)),
                    SizedBox(width: 12),
                    _buildLegendItem('Presentation', Color(0xFFE1D5E7)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Color _getIconColor(String category) {
    switch (category) {
      case 'development':
        return Colors.orange;
      case 'meal':
        return Colors.red;
      case 'interactive':
        return Colors.blue;
      case 'elimination':
        return Colors.green;
      case 'ceremony':
        return Colors.amber;
      case 'presentation':
        return Colors.purple;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}