import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/event_timeline.dart';
import 'dart:ui';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> _highlights = [
    {
      'image': 'assets/images/highlight1.jpg',
      'title': 'Trikon 2.0',
      'subtitle': 'Join the biggest tech event of the year!'
    },
    {
      'image': 'assets/images/highlight2.jpg',
      'title': 'Amazing Prizes',
      'subtitle': 'Win up to \₹11,000 in prizes'
    },
    {
      'image': 'assets/images/highlight3.jpg',
      'title': 'Networking',
      'subtitle': 'Connect with industry experts'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _highlights.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Immersive Hero Banner with Parallax Effect
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero Image with Parallax Effect
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      'assets/images/highlight1.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Frosted Glass Effect
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FadeTransition(
                                  opacity: _animation,
                                  child: const Text(
                                    'TRIKON 2.0',
                                    style: TextStyle(
                                      color: Color(0xFF1E3A8A),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(_animation),
                                  child: const Text(
                                    'Innovation • Technology • Future',
                                    style: TextStyle(
                                      color: Color(0xFF475569),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Feature Banner with 3D Effect
                  Transform.translate(
                    offset: const Offset(0, -20),
                    // child: Container(
                    //   margin: const EdgeInsets.only(bottom: 16),
                    //   padding: const EdgeInsets.all(24),
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         const Color(0xFF3B82F6),
                    //         const Color(0xFF1D4ED8),
                    //       ],
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //     ),
                    //     borderRadius: BorderRadius.circular(20),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: const Color(0xFF3B82F6).withOpacity(0.3),
                    //         blurRadius: 20,
                    //         offset: const Offset(0, 10),
                    //         spreadRadius: 0,
                    //       ),
                    //       BoxShadow(
                    //         color: Colors.white,
                    //         blurRadius: 0,
                    //         offset: const Offset(1, 1),
                    //         spreadRadius: 0,
                    //       ),
                    //     ],
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Container(
                    //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    //               decoration: BoxDecoration(
                    //                 color: Colors.white.withOpacity(0.2),
                    //                 borderRadius: BorderRadius.circular(30),
                    //               ),
                    //               child: const Text(
                    //                 '28-HOUR HACKATHON',
                    //                 style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Colors.white,
                    //                   letterSpacing: 1.2,
                    //                 ),
                    //               ),
                    //             ),
                    //             const SizedBox(height: 12),
                    //             const Text(
                    //               'The Ultimate Tech Experience',
                    //               style: TextStyle(
                    //                 fontSize: 22,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //             const SizedBox(height: 8),
                    //             const Text(
                    //               'Where innovation meets opportunity',
                    //               style: TextStyle(
                    //                 fontSize: 14,
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //             ),
                    //             const SizedBox(height: 16),
                    //             Row(
                    //               children: const [
                    //                 Icon(Icons.calendar_today, color: Colors.white, size: 16),
                    //                 SizedBox(width: 6),
                    //                 Text(
                    //                   'May 3-4, 2025',
                    //                   style: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.w500,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Container(
                    //         width: 80,
                    //         height: 80,
                    //         decoration: BoxDecoration(
                    //           color: Colors.white.withOpacity(0.15),
                    //           shape: BoxShape.circle,
                    //           border: Border.all(
                    //             color: Colors.white.withOpacity(0.5),
                    //             width: 2,
                    //           ),
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Colors.blue.shade800.withOpacity(0.5),
                    //               blurRadius: 12,
                    //               offset: const Offset(0, 5),
                    //             ),
                    //           ],
                    //         ),
                    //         child: ShaderMask(
                    //           shaderCallback: (Rect bounds) {
                    //             return const LinearGradient(
                    //               colors: [Colors.white, Color(0xFFADD8FF)],
                    //               begin: Alignment.topLeft,
                    //               end: Alignment.bottomRight,
                    //             ).createShader(bounds);
                    //           },
                    //           child: const Icon(
                    //             Icons.rocket_launch_rounded,
                    //             color: Colors.white,
                    //             size: 40,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),

                  // Quick Info Cards with Hover Effect
                  FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                icon: Icons.calendar_today_rounded,
                                title: 'May 3-4',
                                subtitle: '28 Hours',
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                icon: Icons.people_alt_rounded,
                                title: 'Teams',
                                subtitle: '3-5 Members',
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                icon: Icons.emoji_events_rounded,
                                title: 'Prizes',
                                subtitle: '\₹11,000+',
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Highlights Carousel with Enhanced Visuals
                  const Text(
                    'Event Highlights',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemCount: _highlights.length,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_pageController.position.haveDimensions) {
                              value = (_pageController.page! - index).abs();
                              value = (1 - (value * 0.3)).clamp(0.7, 1.0);
                            }
                            return Transform.scale(
                              scale: value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 15,
                                        offset: const Offset(0, 10),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (rect) {
                                            return const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [Colors.black, Colors.transparent],
                                              stops: [0.6, 1.0],
                                            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                                          },
                                          blendMode: BlendMode.dstIn,
                                          child: Image.asset(
                                            _highlights[index]['image'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // Gradient overlay for better text visibility
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.7),
                                              ],
                                              stops: const [0.6, 0.95],
                                            ),
                                          ),
                                        ),
                                        // Content
                                        Positioned(
                                          bottom: 20,
                                          left: 20,
                                          right: 20,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _highlights[index]['title'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 3.0,
                                                      color: Color.fromARGB(150, 0, 0, 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                _highlights[index]['subtitle'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 3.0,
                                                      color: Color.fromARGB(150, 0, 0, 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Animated Page Indicator
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_highlights.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == index ? 24.0 : 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  // About the Event with Stylish Design
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF3B82F6),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'About the Event',
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
                          'TRIKON brings together the brightest minds to innovate, collaborate, '
                              'and create groundbreaking solutions. Our hackathon challenges participants to push boundaries, '
                              'think outside the box, and transform ideas into reality. Join us for an unforgettable experience where '
                              'creativity meets technology.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF475569),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Feature Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildFeatureTag('Workshops', Icons.school_rounded),
                            _buildFeatureTag('Mentorship', Icons.psychology_rounded),
                            _buildFeatureTag('Networking', Icons.people_alt_rounded),
                            _buildFeatureTag('Tech Talks', Icons.mic_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Event Timeline Section with Modern Design
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withOpacity(0.9),
                          const Color(0xFF4F46E5).withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Event Timeline',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Event Timeline Widget with custom styling
                        const EventTimeline(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sponsors with Enhanced Visual Appeal
                  const Text(
                    'Our Sponsors',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Premium Sponsors Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rate_rounded,
                              color: Color(0xFFF59E0B),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Platinum Sponsors',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: const [
                              SponsorLogo(
                                image: 'assets/images/sponsor_plat.png',
                                width: 200,
                              ),
                              SponsorLogo(
                                image: 'assets/images/sponsor_plat2.jpg',
                                width: 200,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),




                  // NEW SECTION: Gold Sponsors
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFE0D005),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Gold Sponsors',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: const [
                              SponsorLogo(
                                image: 'assets/images/gold_sponsor.png',
                                width: 180,
                              ),
                              SponsorLogo(
                                image: 'assets/images/sponsor_bronze.jpg',
                                width: 180,
                              ),                              // You can add more gold sponsors the future
                            ],
                          ),
                        ),
                        // const SizedBox(height: 12),
                        // const Text(
                        //   'Providing amazing swag and gifts for all participants',
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     color: Color(0xFF64748B),
                        //     fontStyle: FontStyle.italic,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.workspace_premium,
                              color: Color(0xFFB45309), // Bronze color
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Bronze Sponsors',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: const [
                              // SponsorLogo(
                              //   image: 'assets/images/sponsor_bronze.jpg',
                              //   width: 160,
                              // ),
                              // SponsorLogo(
                              //   image: 'assets/images/sponsor_bronze2.jpg',
                              //   width: 160,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Supporting the tech community',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // NEW SECTION: Swag Sponsors
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.card_giftcard_rounded,
                              color: Color(0xFF8B5CF6),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Swag Sponsors',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: const [
                              SponsorLogo(
                                image: 'assets/images/sponsor_swag.jpg',
                                width: 180,
                              ),
                              SponsorLogo(
                                image: 'assets/images/sponsor_swag3.jpg',
                                width: 180,
                              ),                              // You can add more swag sponsors here in the future
                              SponsorLogo(
                                image: 'assets/images/sponsor_swag2.jpg',
                                width: 180,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                        const Text(
                          'Providing amazing swag and gifts for all participants',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60), // Extra space at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInfoCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFBFDBFE),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF3B82F6),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String day;
  final List<Map<String, String>> events;

  const ScheduleCard({
    super.key,
    required this.day,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                day,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: events.map((event) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width:90,
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event['time']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF334155),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          event['title']!,
                          style: const TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SponsorLogo extends StatelessWidget {
  final String image;
  final double width;

  const SponsorLogo({
    super.key,
    required this.image,
    this.width = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}