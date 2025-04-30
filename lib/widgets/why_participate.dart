import 'package:flutter/material.dart';
import 'dart:async';

class WhyParticipateCarousel extends StatefulWidget {
  const WhyParticipateCarousel({Key? key}) : super(key: key);

  @override
  State<WhyParticipateCarousel> createState() => _WhyParticipateCarouselState();
}

class _WhyParticipateCarouselState extends State<WhyParticipateCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<CarouselItem> _items = [
    CarouselItem(
      title: "Win Cash Prizes",
      description: "Compete for substantial cash rewards that recognize your innovation and hard work.",
      icon: Icons.monetization_on,
      color: Colors.amber,
    ),
    CarouselItem(
      title: "Have Fun",
      description: "Enjoy an exciting weekend of creativity, challenges, and camaraderie with fellow tech enthusiasts.",
      icon: Icons.celebration,
      color: Colors.purple,
    ),
    CarouselItem(
      title: "Learn New Skills",
      description: "Gain hands-on experience with cutting-edge technologies and expand your technical knowledge.",
      icon: Icons.lightbulb,
      color: Colors.blue,
    ),
    CarouselItem(
      title: "Build Your Network",
      description: "Connect with industry experts, recruiters, and like-minded innovators from across the country.",
      icon: Icons.people,
      color: Colors.green,
    ),
    CarouselItem(
      title: "Boost Your Resume",
      description: "Add a prestigious competition credential that stands out to potential employers.",
      icon: Icons.work,
      color: Colors.red,
    ),
    CarouselItem(
      title: "Free meals",
      description: "Stay fueled with complimentary meals and snacks throughout the event so you can focus on creating.",
      icon: Icons.fastfood_outlined,
      color: Colors.yellow,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scrolling timer
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: const Text(
            "Why Participate in Trikon 2025?",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200.0,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return _buildCarouselItem(_items[index]);
            },
          ),
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _items.length,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildCarouselItem(CarouselItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            item.color.withOpacity(0.8),
            item.color.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Icon(
              item.icon,
              size: 36.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class CarouselItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  CarouselItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
