import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? expandedIndex;

  void toggleExpand(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'GOT QUESTIONS?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Find answers to the most common questions about Trikon Hackathon',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),

            // FAQ list
            Expanded(
              child: ListView.builder(
                itemCount: faqItems.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  final faq = faqItems[index];
                  final isExpanded = expandedIndex == index;

                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: InkWell(
                      onTap: () => toggleExpand(index),
                      borderRadius: BorderRadius.circular(12.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    faq['question']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                            if (isExpanded) ...[
                              const SizedBox(height: 12.0),
                              const Divider(),
                              const SizedBox(height: 8.0),
                              Text(
                                faq['answer']!,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FAQ Data
final List<Map<String, String>> faqItems = [
  {
    'question': 'What is Trikon Hackathon?',
    'answer': 'Trikon is a 24-hour hackathon organized by MIET that brings together innovative minds to collaborate and build creative solutions to real-world problems. Participants form teams to develop projects across various domains like AI, web development, blockchain, and more.',
  },
  {
    'question': 'Who can participate?',
    'answer': 'Trikon is open to all college students from any university or institution. Whether you\'re a beginner or an experienced developer, designer, or tech enthusiast, you\'re welcome to join. We encourage diverse teams with varying skill levels and backgrounds.',
  },
  {
    'question': 'Do I need to have a team?',
    'answer': 'While having a team is recommended (teams of 3-5 members), we also offer team formation opportunities during the event. You can register individually, and we\'ll help you find teammates with complementary skills during our team building session.',
  },
  {
    'question': 'Is there any registration fee?',
    'answer': 'Registration for Trikon is completely free. We believe in removing barriers to innovation and collaboration. All participants will receive swag, meals, and access to mentors and workshops at no cost.',
  },
  {
    'question': 'What should I bring to the hackathon?',
    'answer': 'Participants should bring their laptops, chargers, any hardware components for your projects (if applicable), and personal items for an overnight stay. We\'ll provide food, drinks, a comfortable hacking space, and an internet connection.',
  },
  {
    'question': 'Will there be prizes?',
    'answer': 'Yes! Trikon offers exciting prizes for winning teams, including cash rewards, sponsor goodies, internship opportunities, and more. Specific prize details will be announced closer to the event date.',
  },
];