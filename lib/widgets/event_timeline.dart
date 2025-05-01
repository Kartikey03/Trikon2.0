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
            _buildDayHeader(context, 'REGISTRATION - April 18, 2025'),
            _buildDayEvents(context, [
              Event(
                time: 'April 18, 2025',
                title: 'Registration Begins',
                description: 'Submit your team application and prepare for an innovative journey.',
                iconData: Icons.app_registration,
              ),
            ]),
            const SizedBox(height: 16),
            _buildDayHeader(context, 'TEAM SELECTION - April 30, 2025'),
            _buildDayEvents(context, [
              Event(
                time: 'April 30, 2025',
                title: 'Final Teams Announcement',
                description: 'Selected teams will be notified and invited to participate.',
                iconData: Icons.groups_rounded,
              ),
            ]),
            const SizedBox(height: 16),
            _buildDayHeader(context, 'DAY 1 - May 3, 2025'),
            _buildDayEvents(context, [
              Event(
                time: 'Morning',
                title: 'Hackathon Kickoff',
                description: 'Let the TRIKON 2025 Challenge begin!',
                iconData: Icons.rocket_launch_rounded,
              ),
              Event(
                time: 'Afternoon',
                title: 'First Elimination Round',
                description: 'First checkpoint evaluation.',
                iconData: Icons.flag_outlined,
              ),
              Event(
                time: 'Evening',
                title: 'Second Elimination Round',
                description: 'Second checkpoint evaluation.',
                iconData: Icons.flag,
              ),
            ]),
            const SizedBox(height: 16),
            _buildDayHeader(context, 'DAY 2 - May 4, 2025'),
            _buildDayEvents(context, [
              Event(
                time: 'Afternoon',
                title: 'Winners Announcement & Prize Distribution',
                description: 'Celebrate the triumphant champions and their innovative solutions.',
                iconData: Icons.emoji_events,
              ),
              Event(
                time: 'Evening',
                title: 'Hackathon Conclusion & Closing Ceremony',
                description: 'Celebrate achievements and bid farewell to an incredible journey.',
                iconData: Icons.celebration,
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
                const SizedBox(height: 4),
                Text(
                  event.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
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
  final String description;
  final IconData iconData;

  Event({
    required this.time,
    required this.title,
    required this.description,
    required this.iconData,
  });
}