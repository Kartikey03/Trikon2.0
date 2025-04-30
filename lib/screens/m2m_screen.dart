import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class IntegratedM2MScreen extends StatefulWidget {
  const IntegratedM2MScreen({super.key});

  @override
  _IntegratedM2MScreenState createState() => _IntegratedM2MScreenState();
}

class _IntegratedM2MScreenState extends State<IntegratedM2MScreen> {
  // Schedule items will now be loaded from Firebase
  List<Map<String, dynamic>> _scheduleItems = [];

  // Loading state
  bool _isLoading = true;
  String? _errorMessage;

  // Filter by category and date
  String? _selectedCategory;
  String? _selectedDate;
  bool _showCurrentOnly = false;

  // Date options
  final List<Map<String, String>> _dateOptions = [
    {'value': '2025-05-03', 'display': 'May 3, 2025'},
    {'value': '2025-05-04', 'display': 'May 4, 2025'},
  ];

  // Firebase reference
  late final DatabaseReference _scheduleRef;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase database reference
    _scheduleRef =
        FirebaseDatabase.instance.ref().child('trikon2025').child('m2m');

    // Set default selected date to today if it's one of the hackathon days, otherwise first day
    final now = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(now);
    if (_dateOptions.any((date) => date['value'] == todayString)) {
      _selectedDate = todayString;
    } else {
      _selectedDate = _dateOptions.first['value'];
    }

    // Load data
    _loadScheduleData();
  }

  // Load schedule data from Firebase
  Future<void> _loadScheduleData() async {
    try {
      // Listen for changes in the schedule data
      _scheduleRef.onValue.listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            _isLoading = false;

            // Convert the data from Firebase to our List<Map> format
            final data = event.snapshot.value as Map<dynamic, dynamic>;
            _scheduleItems = [];

            data.forEach((key, value) {
              if (value is Map<dynamic, dynamic>) {
                final item = Map<String, dynamic>.from({
                  'id': key,
                  ...Map<String, dynamic>.from(value.map(
                        (key, value) => MapEntry(key.toString(), value),
                  )),
                });

                // Make sure each item has a date
                if (!item.containsKey('date')) {
                  // Default to first day if no date is specified
                  item['date'] = _dateOptions.first['value'];
                }

                _scheduleItems.add(item);
              }
            });

            // Sort schedule items by date first, then by start time
            _scheduleItems.sort((a, b) {
              int dateComparison = a['date'].compareTo(b['date']);
              if (dateComparison != 0) return dateComparison;
              return _compareTimeStrings(a['startTime'], b['startTime']);
            });
          });
        } else {
          setState(() {
            _isLoading = false;
            _scheduleItems = [];
          });
        }
      }, onError: (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load schedule: $error";
        });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error: $e";
      });
    }
  }

  // Helper function to compare time strings for sorting
  int _compareTimeStrings(String time1, String time2) {
    // Extract hours and minutes from time strings and convert to 24-hour format
    int getTimeValue(String timeStr) {
      final parts = timeStr.split(' ');
      final timePart = parts[0];
      final amPm = parts[1].toLowerCase();

      final hourMinute = timePart.split(':');
      int hour = int.parse(hourMinute[0]);
      final int minute = int.parse(hourMinute[1]);

      // Convert to 24-hour format
      if (amPm == 'p.m.' && hour < 12) {
        hour += 12;
      } else if (amPm == 'a.m.' && hour == 12) {
        hour = 0;
      }

      return hour * 60 + minute;
    }

    return getTimeValue(time1) - getTimeValue(time2);
  }

  // Get the current event
  Map<String, dynamic>? _getCurrentEvent() {
    if (_scheduleItems.isEmpty) return null;

    // Get current date and time
    final now = DateTime.now();
    final currentDateStr = DateFormat('yyyy-MM-dd').format(now);
    int currentHour = now.hour;
    int currentMinute = now.minute;

    // Function to parse time string to hour and minute
    Map<String, int> parseTimeString(String timeStr) {
      final parts = timeStr.split(' ');
      final timePart = parts[0];
      final amPm = parts[1].toLowerCase();

      final hourMinute = timePart.split(':');
      int hour = int.parse(hourMinute[0]);
      final int minute = int.parse(hourMinute[1]);

      // Convert to 24-hour format
      if (amPm == 'p.m.' && hour < 12) {
        hour += 12;
      } else if (amPm == 'a.m.' && hour == 12) {
        hour = 0;
      }

      return {'hour': hour, 'minute': minute};
    }

    // Find current event for today
    for (final event in _scheduleItems) {
      // Skip events not from today
      if (event['date'] != currentDateStr) continue;

      final startTime = parseTimeString(event['startTime']);
      final endTime = parseTimeString(event['endTime']);

      final eventStartValue = startTime['hour']! * 60 + startTime['minute']!;
      final eventEndValue = endTime['hour']! * 60 + endTime['minute']!;
      final currentValue = currentHour * 60 + currentMinute;

      if (currentValue >= eventStartValue && currentValue < eventEndValue) {
        return event;
      }
    }

    // If no current event, return the next upcoming event for today
    for (final event in _scheduleItems) {
      // First try to find upcoming event today
      if (event['date'] == currentDateStr) {
        final startTime = parseTimeString(event['startTime']);
        final eventStartValue = startTime['hour']! * 60 + startTime['minute']!;
        final currentValue = currentHour * 60 + currentMinute;

        if (eventStartValue > currentValue) {
          return event;
        }
      }
    }

    // If not found, check for the first event of the next day in our event range
    for (final dateOption in _dateOptions) {
      final dateStr = dateOption['value']!;
      // Convert strings to DateTime objects for proper comparison
      final dateOptionDateTime = DateTime.parse(dateStr);
      final currentDateTime = DateTime.parse(currentDateStr);

      if (dateOptionDateTime.isAfter(currentDateTime)) {
        for (final event in _scheduleItems) {
          if (event['date'] == dateStr) {
            return event; // Return the first event of the next day
          }
        }
      }
    }

    // If all else fails, return the first event
    return _scheduleItems.first;
  }

  // Get color based on event category
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'entry':
        return Colors.grey.shade100;
      case 'ceremony':
        return const Color(0xFFE3D596).withOpacity(0.2); // Gold
      case 'general':
        return Colors.grey.shade100;
      case 'development':
        return const Color(0xFF8EB98E); // Light yellow
      case 'meal':
        return const Color(0xFFD2CE98); // Light red/pink
      case 'interactive':
        return const Color(0xFF8CB5CC); // Light blue
      case 'elimination':
        return const Color(0xFFBB8888); // Light green
      case 'presentation':
        return const Color(0xFFC299DC); // Light purple
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

  // Format date from yyyy-MM-dd to readable format
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE, MMMM d, yyyy').format(
          date); // e.g. "Saturday, May 3, 2025"
    } catch (e) {
      return dateStr;
    }
  }

  // Get filtered schedule items
  List<Map<String, dynamic>> _getFilteredSchedule() {
    return _scheduleItems.where((item) {
      // Filter by category if selected
      if (_selectedCategory != null && item['category'] != _selectedCategory) {
        return false;
      }

      // Filter by date if selected
      if (_selectedDate != null && item['date'] != _selectedDate) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSchedule = _getFilteredSchedule();
    final currentEvent = _getCurrentEvent();

    // Loading state
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Theme
          .of(context)
          .scaffoldBackgroundColor,
      child: Column(
        children: [
          // Status bar space
          SizedBox(height: MediaQuery
              .of(context)
              .padding
              .top + kToolbarHeight),

          // Current Event Card
          if (currentEvent == null)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No event is currently happening",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          else
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
                      Theme
                          .of(context)
                          .primaryColor
                          .withOpacity(0.8),
                      Theme
                          .of(context)
                          .primaryColor,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${currentEvent?['startTime']} - ${currentEvent?['endTime'] ??
                                'Ongoing'}",
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
                      currentEvent?['description'] ??
                          "Event details loading...",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category info
                        Row(
                          children: [
                            Icon(
                              _getCategoryIcon(
                                  currentEvent?['category'] ?? 'general'),
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getCategoryName(
                                  currentEvent?['category'] ?? 'general'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Date info
                        if (currentEvent != null &&
                            currentEvent.containsKey('date'))
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatDateShort(currentEvent['date']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Event Schedule",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    // Date filter
                    Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _selectedDate,
                          icon: const Icon(Icons.calendar_today, size: 18),
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge!
                                .color,
                            fontSize: 14,
                          ),
                          isDense: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDate = newValue;
                            });
                          },
                          items: [
                            ..._dateOptions.map((date) {
                              return DropdownMenuItem<String>(
                                value: date['value'],
                                child: Text(_formatDateShort(date['value']!)),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),

                    // Category filter
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
                            color: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge!
                                .color,
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
                              child: Text("All Categories"),
                            ),
                            ...[
                              'entry',
                              'ceremony',
                              'general',
                              'development',
                              'meal',
                              'interactive',
                              'elimination',
                              'presentation'
                            ].map((String category) {
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
              ],
            ),
          ),

          // Display current date heading
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatDate(_selectedDate!),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: Card(
                    elevation: isCurrent ? 2 : 1,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isCurrent
                          ? BorderSide(color: Theme
                          .of(context)
                          .primaryColor, width: 2)
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
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? Theme
                                      .of(context)
                                      .primaryColor
                                      : Theme
                                      .of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    _getCategoryIcon(item['category']),
                                    color: isCurrent
                                        ? Colors.white
                                        : _getIconColor(item['category']),
                                  ),
                                ),
                              ),
                              title: Text(
                                item['activity'],
                                style: TextStyle(
                                  fontWeight: isCurrent
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    // Show time
                                    Text(
                                      "${item['startTime']} - ${item['endTime'] ??
                                          'Ongoing'}",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
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
                _buildLegendItem('Dev', const Color(0xFF21F508), Icons.code),
                _buildLegendItem(
                    'Food', const Color(0xFFE0D005), Icons.restaurant),
                _buildLegendItem(
                    'Interactive', const Color(0xFF0097FF), Icons.people),
                _buildLegendItem(
                    'Elimination', const Color(0xFFFC0505), Icons.filter_list),
                _buildLegendItem('Presentation', const Color(0xFFAA00FF),
                    Icons.present_to_all),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Format date to short display (May 3)
  String _formatDateShort(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d').format(date); // e.g. "May 3"
    } catch (e) {
      return dateStr;
    }
  }

  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.6,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time info
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${event['startTime']} - ${event['endTime'] ??
                                    'Ongoing'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                          // Date info
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatDateShort(event['date']),
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
                          event['description'] ??
                              "No additional details available for this event.",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Event tips (based on category)
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
                            Icons.tips_and_updates,
                          ),

                        if (event['category'] == 'meal')
                          _buildTipSection(
                            "Meal Break Tips",
                            "Take this opportunity to network with other participants and mentors. Remember to stay hydrated and energized for the upcoming activities.",
                            Icons.restaurant_menu,
                          ),

                        if (event['category'] == 'interactive')
                          _buildTipSection(
                            "Interactive Session Tips",
                            "Actively participate and share your ideas. This is a great opportunity to learn from others and get feedback on your concepts.",
                            Icons.people,
                          ),

                        if (event['category'] == 'elimination')
                          _buildTipSection(
                            "Elimination Round Tips",
                            "Make sure your project meets all the requirements. Focus on demonstrating the core functionality clearly and effectively.",
                            Icons.format_list_numbered,
                          ),

                        // Location information if available
                        if (event.containsKey('location') &&
                            event['location'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Location",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      event['location'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),

                        // Close button
                        Center(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("Close"),
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
  }

  // Category name function
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
        return 'Meal';
      case 'interactive':
        return 'Interactive';
      case 'elimination':
        return 'Elimination';
      case 'presentation':
        return 'Presentation';
      default:
        return 'Event';
    }
  }

  // Icon color function
  Color _getIconColor(String category) {
    switch (category) {
      case 'entry':
        return Colors.grey.shade700;
      case 'ceremony':
        return const Color(0xFFD4AF37); // Gold
      case 'general':
        return Colors.grey.shade700;
      case 'development':
        return const Color(0xFF13EF0C); // Yellow/gold
      case 'meal':
        return const Color(0xFFFFFA00); // Red
      case 'interactive':
        return const Color(0xFF0075EC); // Blue
      case 'elimination':
        return const Color(0xFFFC0505); // Green
      case 'presentation':
        return const Color(0xFF8E7CC3); // Purple
      default:
        return Colors.grey.shade700;
    }
  }

// Legend item function
  Widget _buildLegendItem(String label, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

// Tip section function
  Widget _buildTipSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme
                  .of(context)
                  .primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .primaryColor
                .withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(0.2),
            ),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}