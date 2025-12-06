
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/features/animals/presentation/pages/animals_page.dart';
import 'package:kids/features/colors/presentation/pages/colors_page.dart';
import 'package:kids/features/drawing/presentation/pages/drawing_page.dart';
import 'package:kids/features/fruits/presentation/pages/fruits_page.dart';
import 'package:kids/features/gk/presentation/pages/gk_page.dart';
import 'package:kids/features/learning/presentation/pages/spelling_page.dart';
import 'package:kids/features/mascot/presentation/pages/dressing_room_page.dart';
import 'package:kids/features/mascot/presentation/pages/feeding_room_page.dart';
import 'package:kids/features/mascot/presentation/provider/mascot_provider.dart';
import 'package:kids/features/puzzles/presentation/pages/puzzles_page.dart';
import 'package:kids/features/quiz/presentation/pages/quiz_selection_page.dart';
import 'package:kids/features/rewards/presentation/pages/sticker_album_page.dart';
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
    final features = [
      _FeatureData('Alphabet', Icons.abc, Colors.red, () => Navigator.pushNamed(context, AlphabetPage.routeName)),
      _FeatureData('Numbers', Icons.format_list_numbered, Colors.orange, () => Navigator.pushNamed(context, NumbersPage.routeName)),
      _FeatureData('Spelling', Icons.spellcheck, Colors.teal, () => Navigator.pushNamed(context, SpellingPage.routeName)),
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
      _FeatureData('Stickers', Icons.star_border, Colors.purpleAccent, () => Navigator.pushNamed(context, StickerAlbumPage.routeName)),
      _FeatureData('GK', Icons.lightbulb, Colors.indigo, () => Navigator.pushNamed(context, GKPage.routeName)),
    ];

    return GridView.builder(
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemCount: features.length,
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

class _FeatureData {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _FeatureData(this.label, this.icon, this.color, this.onTap);
}

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
          SoundManager().playPop(); 
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

class CartoonMascot extends StatefulWidget {
  final double size;
  const CartoonMascot({super.key, required this.size});

  @override
  State<CartoonMascot> createState() => _CartoonMascotState();
}

class _CartoonMascotState extends State<CartoonMascot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    // Bounce controller for tap interaction
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: 200), () {
       if(mounted) Navigator.pushNamed(context, DressingRoomPage.routeName);
    });
  }

  void _handleFeedTap() {
    SoundManager().playPop();
    Navigator.pushNamed(context, FeedingRoomPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // Reduce size slightly for a tighter look
    final double displaySize = widget.size * 0.9;

    return Consumer<MascotProvider>(
      builder: (context, mascotProvider, child) {
        final equippedHat = mascotProvider.equippedHatId != null
            ? mascotProvider.availableAccessories.firstWhere((acc) => acc.id == mascotProvider.equippedHatId)
            : null;

        final equippedGlasses = mascotProvider.equippedGlassesId != null
            ? mascotProvider.availableAccessories.firstWhere((acc) => acc.id == mascotProvider.equippedGlassesId)
            : null;

        return SizedBox(
          width: displaySize + 80, // Space for side buttons
          height: displaySize + 20,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
               // 1. Magical Glow (Pedestal)
              Positioned(
                bottom: 10,
                child: Container(
                  width: displaySize * 0.8,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.yellow.withOpacity(0.3), blurRadius: 20, spreadRadius: 5),
                    ]
                  ),
                ),
              ),
              
              // 2. Mascot (Main)
              GestureDetector(
                onTap: _handleTap,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final bounce = sin(_controller.value * 2 * pi) * 10; 
                    return Transform.translate(
                      offset: Offset(0, -bounce),
                      child: child,
                    );
                  },
                  child: Lottie.asset(
                    'assets/animations/mascot.json', 
                    width: displaySize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // 3. Accessories (Adjusted for new size)
              if (equippedHat != null)
                Positioned(
                  top: 5,
                  child: IgnorePointer(child: _getAccessoryIcon(equippedHat, displaySize * 0.35)),
                ),
              if (equippedGlasses != null)
                Positioned(
                  top: displaySize * 0.25,
                  child: IgnorePointer(child: _getAccessoryIcon(equippedGlasses, displaySize * 0.3)),
                ),

              // 4. "Feed Me" Button (Floating Apple)
              Positioned(
                right: 0,
                bottom: 20,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 10),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    final offset = sin(value * pi) * 5; 
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    );
                  },
                  onEnd: () {},
                  child: GestureDetector(
                    onTap: _handleFeedTap,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 3))],
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: const Text('🍎', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getAccessoryIcon(MascotAccessory accessory, double iconSize) {
    if (accessory.id.startsWith('hat')) {
      return Icon(Icons.school, size: iconSize, color: Colors.brown);
    } else if (accessory.id.startsWith('glasses')) {
      return Icon(Icons.visibility, size: iconSize, color: Colors.black);
    }
    return Icon(Icons.error, size: iconSize);
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
