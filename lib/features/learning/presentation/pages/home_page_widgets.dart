
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids/features/animals/presentation/pages/animals_page.dart';
import 'package:kids/features/colors/presentation/pages/colors_page.dart';
import 'package:kids/features/drawing/presentation/pages/drawing_page.dart';
import 'package:kids/features/fruits/presentation/pages/fruits_page.dart';
import 'package:kids/features/gk/presentation/pages/gk_page.dart';
import 'package:kids/features/mascot/presentation/pages/dressing_room_page.dart';
import 'package:kids/features/mascot/presentation/provider/mascot_provider.dart';
import 'package:kids/features/puzzles/presentation/pages/puzzles_page.dart';
import 'package:kids/features/quiz/presentation/pages/quiz_selection_page.dart';
import 'package:kids/features/rhymes/presentation/pages/rhymes_page.dart';
import 'package:kids/features/shapes/presentation/pages/shapes_page.dart';
import 'package:kids/features/stories/presentation/pages/stories_page.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:lottie/lottie.dart';
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
          colors: [Color(0xFF6A82FB), Color(0xFFFC5286)],
        ),
      ),
      child: Stack(
        children: [
          // Stars
          for (int i = 0; i < 10; i++)
            Positioned(
              top: Random().nextDouble() * 300,
              left: Random().nextDouble() * MediaQuery.of(context).size.width,
              child: const Icon(Icons.star, color: Colors.yellow, size: 15),
            ),
          // Rainbow
          Positioned(
            top: 50,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Colors.red.withOpacity(0.5),
                    Colors.orange.withOpacity(0.5),
                    Colors.yellow.withOpacity(0.5),
                    Colors.green.withOpacity(0.5),
                    Colors.blue.withOpacity(0.5),
                    Colors.indigo.withOpacity(0.5),
                    Colors.purple.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          // Floating Islands
          Positioned(
            bottom: 150,
            left: 50,
            child: _buildFloatingIsland(),
          ),
          Positioned(
            bottom: 250,
            right: 30,
            child: _buildFloatingIsland(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIsland() {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.brown.shade300,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }
}

class FeatureCarousel extends StatelessWidget {
  const FeatureCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    // A list of all features to be displayed in the grid.
    final features = [
      _FeatureData('Alphabet', Icons.abc, Colors.red, () => Navigator.pushNamed(context, AlphabetPage.routeName)),
      _FeatureData('Numbers', Icons.format_list_numbered, Colors.orange, () => Navigator.pushNamed(context, NumbersPage.routeName)),
      _FeatureData('Rhymes', Icons.music_note, Colors.purple, () => Navigator.pushNamed(context, RhymesPage.routeName)),
      _FeatureData('Drawing', Icons.brush, Colors.blue, () => Navigator.pushNamed(context, DrawingPage.routeName)),
      _FeatureData('Coloring', Icons.palette, Colors.pink, () => Navigator.pushNamed(context, ColorsPage.routeName)),
      _FeatureData('Shapes', Icons.category, Colors.green, () => Navigator.pushNamed(context, ShapesPage.routeName)),
      _FeatureData('Animals', Icons.pets, Colors.brown, () => Navigator.pushNamed(context, AnimalsPage.routeName)),
      _FeatureData('Fruits', Icons.apple, Colors.redAccent, () => Navigator.pushNamed(context, FruitsPage.routeName)),
      _FeatureData('Stories', Icons.book, Colors.teal, () => Navigator.pushNamed(context, StoriesPage.routeName)),
      _FeatureData('Games', Icons.games, Colors.amber, () => Navigator.pushNamed(context, QuizSelectionPage.routeName)),
      _FeatureData('Puzzles', Icons.extension, Colors.deepOrange, () => Navigator.pushNamed(context, PuzzlesPage.routeName)),
      _FeatureData('Quiz', Icons.question_answer, Colors.cyan, () => Navigator.pushNamed(context, QuizSelectionPage.routeName)),
      _FeatureData('GK', Icons.lightbulb, Colors.indigo, () => Navigator.pushNamed(context, GKPage.routeName)),
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemCount: features.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final feature = features[index];
        return AnimatedFeatureIcon(
          label: feature.label,
          icon: feature.icon,
          color: feature.color,
          onTap: feature.onTap,
        );
      },
    );
  }
}

// A simple data class for feature properties.
class _FeatureData {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _FeatureData(this.label, this.icon, this.color, this.onTap);
}

// The new animated feature icon with a bouncy effect on tap.
class AnimatedFeatureIcon extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AnimatedFeatureIcon({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<AnimatedFeatureIcon> createState() => _AnimatedFeatureIconState();
}

class _AnimatedFeatureIconState extends State<AnimatedFeatureIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
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
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
              // Inner shadow for 3D effect
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 1,
                spreadRadius: 1,
                offset: const Offset(-1, -1),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), offset: const Offset(0, 4), blurRadius: 8)],
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), offset: const Offset(0, 4), blurRadius: 8)],
      ),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Icon(Icons.settings, color: Colors.grey, size: 28),
      ),
    );
  }
}
