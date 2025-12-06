
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids/features/parent_settings/presentation/pages/create_profile_page.dart';
import 'package:kids/features/learning/presentation/pages/home_page.dart';
import 'package:kids/features/parent_settings/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Hide status bar for a cleaner splash screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();

    // Navigate after a delay
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    // Restore system UI before navigating
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    
    // Check if profile exists, then navigate accordingly
    if (profileProvider.hasProfile) {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(CreateProfilePage.routeName);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Restore UI
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade300, Colors.blue.shade100],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/icons/kids_app_logo.png', // Use your app logo asset
                  width: 150, height: 150, errorBuilder: (context, _, __) => 
                    const Icon(Icons.apps, size: 150, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Text(
                  'Kids Learning App',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 8)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
