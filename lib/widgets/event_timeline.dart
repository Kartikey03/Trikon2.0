import 'package:flutter/material.dart';

class EventTimeline extends StatelessWidget {
  const EventTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5C66F5), // Blue background color like in the image
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDayHeader(context, 'DAY 1 - May 3, 2025'),
            _buildDayEvents(context, [
              Event(
                time: '9:00 AM',
                title: 'Registration & Welcome Kit',
                iconData: Icons.app_registration,
              ),
              Event(
                time: '10:00 AM',
                title: 'Opening Ceremony',
                iconData: Icons.celebration,
              ),
              Event(
                time: '11:00 AM',
                title: 'Problem Statement Release',
                iconData: Icons.lightbulb_outline,
              ),
              Event(
                time: '12:00 PM',
                title: 'Team Formation & Networking Lunch',
                iconData: Icons.groups_rounded,
              ),
              Event(
                time: '2:00 PM',
                title: 'Hackathon Begins',
                iconData: Icons.rocket_launch_rounded,
              ),
              Event(
                time: '6:00 PM',
                title: 'Mentorship Sessions',
                iconData: Icons.person_outline,
              ),
              Event(
                time: '8:00 PM',
                title: 'Dinner',
                iconData: Icons.dinner_dining,
              ),
            ]),
            const SizedBox(height: 16),
            _buildDayHeader(context, 'DAY 2 - May 4, 2025'),
            _buildDayEvents(context, [
              Event(
                time: '8:00 AM',
                title: 'Breakfast',
                iconData: Icons.breakfast_dining,
              ),
              Event(
                time: '10:00 AM',
                title: 'First Checkpoint',
                iconData: Icons.flag_outlined,
              ),
              Event(
                time: '12:00 PM',
                title: 'Lunch',
                iconData: Icons.lunch_dining,
              ),
              Event(
                time: '3:00 PM',
                title: 'Second Checkpoint',
                iconData: Icons.flag,
              ),
              Event(
                time: '5:00 PM',
                title: 'Final Submissions',
                iconData: Icons.upload_file,
              ),
              Event(
                time: '6:30 PM',
                title: 'Project Presentations',
                iconData: Icons.present_to_all,
              ),
              Event(
                time: '8:00 PM',
                title: 'Winners Announcement & Closing Ceremony',
                iconData: Icons.emoji_events,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDayHeader(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDayEvents(BuildContext context, List<Event> events) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: events.map((event) => _buildEventItem(context, event)).toList(),
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, Event event) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              event.iconData,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String time;
  final String title;
  final IconData iconData;

  Event({
    required this.time,
    required this.title,
    required this.iconData,
  });
}