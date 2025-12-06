
import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/features/mascot/presentation/provider/mascot_provider.dart';
import 'package:kids/features/rewards/presentation/provider/achievements_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FeedingRoomPage extends StatefulWidget {
  static const routeName = '/feeding-room';
  const FeedingRoomPage({super.key});

  @override
  State<FeedingRoomPage> createState() => _FeedingRoomPageState();
}

class _FeedingRoomPageState extends State<FeedingRoomPage> with SingleTickerProviderStateMixin {
  late AnimationController _mascotController;
  
  // Simple state for reaction
  bool _isEating = false;
  String _reactionEmoji = '';

  final List<FoodItem> _foods = [
    FoodItem('Apple', '🍎', Colors.red.shade100),
    FoodItem('Banana', '🍌', Colors.yellow.shade100),
    FoodItem('Grapes', '🍇', Colors.purple.shade100),
    FoodItem('Burger', '🍔', Colors.orange.shade100),
    FoodItem('Cookie', '🍪', Colors.brown.shade100),
    FoodItem('Milk', '🥛', Colors.blue.shade100),
  ];

  @override
  void initState() {
    super.initState();
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _mascotController.dispose();
    super.dispose();
  }

  void _onFoodDropped(FoodItem food) {
    setState(() {
      _isEating = true;
      _reactionEmoji = '😋';
    });

    // Play Sound
    SoundManager().playPop(); 

    // Animate Mascot
    _mascotController.repeat(reverse: true);
    
    // Achievement: Pet Sitter
    context.read<AchievementsProvider>().incrementProgress('pet_sitter');
    
    // Reset after eating duration
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _mascotController.stop();
        _mascotController.reset();
        setState(() {
          _isEating = false;
          _reactionEmoji = '❤️'; 
        });
        
        // Hide reaction after a bit
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _reactionEmoji = '');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 1. Mascot Area (Target)
            Expanded(
              flex: 3,
              child: DragTarget<FoodItem>(
                onWillAccept: (data) => !_isEating, 
                onAccept: _onFoodDropped,
                builder: (context, candidateData, rejectedData) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Mascot
                      AnimatedBuilder(
                        animation: _mascotController,
                        builder: (context, child) {
                          // Simple "Nom Nom" scaling effect
                          double scale = 1.0 + (_mascotController.value * 0.1);
                          return Transform.scale(
                            scale: scale,
                            child: Lottie.asset(
                              'assets/animations/mascot.json',
                              width: 250,
                              height: 250,
                            ),
                          );
                        },
                      ),
                      
                      // Reaction Bubble
                      if (_reactionEmoji.isNotEmpty)
                        Positioned(
                          top: 20,
                          right: 40,
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 400),
                            builder: (context, val, child) {
                              return Transform.scale(
                                scale: val,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                                  ),
                                  child: Text(_reactionEmoji, style: const TextStyle(fontSize: 40)),
                                ),
                              );
                            },
                          ),
                        ),
                        
                      // Hint
                      if (candidateData.isNotEmpty)
                        Positioned(
                          bottom: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Feed Me!',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            // 2. Food Shelf (Source)
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0, left: 8.0),
                      child: Text('Yummy Snacks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown)),
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _foods.length,
                        itemBuilder: (context, index) {
                          final food = _foods[index];
                          return Draggable<FoodItem>(
                            data: food,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Text(food.emoji, style: const TextStyle(fontSize: 60)),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: _buildFoodCard(food),
                            ),
                            child: _buildFoodCard(food),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    return Container(
      decoration: BoxDecoration(
        color: food.bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(food.emoji, style: const TextStyle(fontSize: 40)),
      ),
    );
  }
}

class FoodItem {
  final String name;
  final String emoji;
  final Color bgColor;
  FoodItem(this.name, this.emoji, this.bgColor);
}
