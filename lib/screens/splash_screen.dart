import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for Lottie animation only
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Match the actual animation duration of 0.5 seconds
    );

    // Start the animation and loop
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });

    // Navigate to the next screen after a delay
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => widget.nextScreen),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background color
          Container(
            color: Colors.white,
          ),

          // Repositioned layout using Column for better positioning
          Column(
            children: [
              // Empty space at the top
              const SizedBox(height: 140),

              // Logo positioned between top and middle with proper circular clipping
              SizedBox(
                height: 150,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/trikon_logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Spacer to push animation below middle
              const Spacer(),

              // Lottie animation positioned between middle and bottom
              SizedBox(
                height: 300,
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  controller: _controller,
                  fit: BoxFit.contain,
                  frameRate: FrameRate(60),
                  repeat: true,
                ),
              ),

              // Space at bottom
              const SizedBox(height: 100),
            ],
          ),
        ],
      ),
    );
  }
}