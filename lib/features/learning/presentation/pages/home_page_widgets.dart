// lib/features/learning/presentation/pages/home_page_widgets.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids/features/colors/presentation/pages/colors_page.dart';
import 'package:kids/features/rhymes/presentation/pages/rhymes_page.dart';
import 'package:kids/features/shapes/presentation/pages/shapes_page.dart';
import 'package:kids/features/stories/presentation/pages/stories_page.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:provider/provider.dart';
import 'alphabet_page.dart';
import 'numbers_page.dart';

class CartoonBackground extends StatelessWidget {
  const CartoonBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF81C7F5), Color(0xFFB3E5FC)], // Sky Blue Gradient
        ),
      ),
      child: Stack(
        children: [
          // Floating clouds
          _buildCloud(top: 100, left: -50, size: 150),
          _buildCloud(top: 250, right: -60, size: 120),
          _buildCloud(top: 400, left: 20, size: 80),
          _buildCloud(bottom: 100, right: 20, size: 100),
        ],
      ),
    );
  }

  Widget _buildCloud({double? top, double? bottom, double? left, double? right, required double size}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Icon(
        Icons.cloud,
        color: Colors.white.withOpacity(0.5),
        size: size,
      ),
    );
  }
}

class CartoonMascot extends StatelessWidget {
  final double size;
  const CartoonMascot({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const Icon(
        Icons.face, // Placeholder for a cute mascot
        color: Colors.orangeAccent,
        size: 100,
      ),
    );
  }
}

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Hello, Friend!",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "What will we learn today?",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

class BubblyBottomPanel extends StatelessWidget {
  final Widget child;
  const BubblyBottomPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: size.height * 0.55,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6AE398), Color(0xFF50C878)], // Grassy Green Gradient
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, -10),
              blurRadius: 20,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class LearningWorldsGrid extends StatelessWidget {
  const LearningWorldsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        HomeFeatureBubble(
          label: "Alphabet",
          icon: Icons.abc, // Corrected Icon
          startColor: const Color(0xFFFF7B9C),
          endColor: const Color(0xFFFF5F6D),
          onTap: () => Navigator.pushNamed(context, AlphabetPage.routeName),
        ),
        HomeFeatureBubble(
          label: "Numbers",
          icon: Icons.format_list_numbered,
          startColor: const Color(0xFF6FD6FF),
          endColor: const Color(0xFF4DA6FF),
          onTap: () => Navigator.pushNamed(context, NumbersPage.routeName),
        ),
        HomeFeatureBubble(
          label: "Colors",
          icon: Icons.palette,
          startColor: const Color(0xFF9B88FF),
          endColor: const Color(0xFF7F5CFF),
          onTap: () => Navigator.pushNamed(context, ColorsPage.routeName),
        ),
        HomeFeatureBubble(
          label: "Shapes",
          icon: Icons.category,
          startColor: const Color(0xFFFFC94F),
          endColor: const Color(0xFFFFA726),
          onTap: () => Navigator.pushNamed(context, ShapesPage.routeName),
        ),
        HomeFeatureBubble(
          label: "Rhymes",
          icon: Icons.music_note,
          startColor: const Color(0xFF80E27E),
          endColor: const Color(0xFF4CAF50),
          onTap: () => Navigator.pushNamed(context, RhymesPage.routeName),
        ),
        HomeFeatureBubble(
          label: "Stories",
          icon: Icons.menu_book,
          startColor: const Color(0xFFFF8A65),
          endColor: const Color(0xFFF4511E),
          onTap: () => Navigator.pushNamed(context, StoriesPage.routeName),
        ),
      ],
    );
  }
}

class StarCounter extends StatelessWidget {
  const StarCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final rewardsProvider = Provider.of<RewardsProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.yellow, size: 24),
          const SizedBox(width: 8),
          Text(
            '${rewardsProvider.rewardState.totalStars}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Icon(Icons.settings, color: Colors.grey, size: 28),
      ),
    );
  }
}

class HomeFeatureBubble extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  final VoidCallback onTap;

  const HomeFeatureBubble({
    super.key,
    required this.label,
    required this.icon,
    required this.startColor,
    required this.endColor,
    required this.onTap,
  });

  @override
  State<HomeFeatureBubble> createState() => _HomeFeatureBubbleState();
}

class _HomeFeatureBubbleState extends State<HomeFeatureBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.startColor, widget.endColor],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 10),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
