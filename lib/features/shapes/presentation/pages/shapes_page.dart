// lib/features/shapes/presentation/pages/shapes_page.dart

import 'package:flutter/material.dart';
import 'package:kids/features/challenges/presentation/provider/daily_challenge_provider.dart';
import 'package:kids/features/learning/presentation/provider/learning_provider.dart';
import 'package:provider/provider.dart';
import '../provider/shapes_provider.dart';
import '../widgets/shape_tile.dart';
import '../../domain/entities/shape_item.dart';
import '../../../rewards/presentation/provider/rewards_provider.dart';
import '../../../rewards/presentation/widgets/reward_popup.dart';
import 'dart:math';

class ShapesPage extends StatefulWidget {
  const ShapesPage({super.key});
  static const routeName = '/shapes';

  @override
  State<ShapesPage> createState() => _ShapesPageState();
}

class _ShapesPageState extends State<ShapesPage> with TickerProviderStateMixin {
  bool _gameActive = false;
  String _gameMessage = '';
  ShapeItem? _target;
  bool _didInit = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ShapesProvider>(context, listen: false).load();
      });
      _didInit = true;
    }
  }

  void _startGame() {
    final prov = Provider.of<ShapesProvider>(context, listen: false);
    if (prov.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shapes are still loading...')));
      return;
    }
    final rnd = Random();
    final selected = prov.items[rnd.nextInt(prov.items.length)];
    _target = selected;
    setState(() {
      _gameActive = true;
      _gameMessage = 'Tap the ${_target!.displayText}!';
    });
    prov.speak(_target!);
  }

  void _onShapeTap(ShapeItem item) {
    final shapesProvider = Provider.of<ShapesProvider>(context, listen: false);
    final learningProvider = Provider.of<LearningProvider>(context, listen: false);
    final challengeProvider = Provider.of<DailyChallengeProvider>(context, listen: false);
    final rewardsProvider = Provider.of<RewardsProvider>(context, listen: false);

    shapesProvider.speak(item);

    if (!learningProvider.completedShapes.contains(item.name)) {
      challengeProvider.updateProgress(ChallengeType.LearnShapes);
    }
    learningProvider.markShapeAsLearned(item.name);

    _animationController.forward().then((_) => _animationController.reverse());
    if (_gameActive) {
      if (_target != null && item.id == _target!.id) {
        setState(() {
          _gameActive = false;
          _gameMessage = 'Great job! You found the ${_target!.displayText}!';
        });
        rewardsProvider.awardStar();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const RewardPopup();
          },
        );
      } else {
        setState(() {
          _gameMessage = 'Try again! Tap the ${_target?.displayText ?? 'shape'}.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shapesProvider = Provider.of<ShapesProvider>(context);
    final learningProvider = Provider.of<LearningProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Shapes'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: shapesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade50, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Play a Game!', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  if (_gameMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(_gameMessage, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(24.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 24.0,
                        mainAxisSpacing: 24.0,
                      ),
                      itemCount: shapesProvider.items.length,
                      itemBuilder: (context, index) {
                        final item = shapesProvider.items[index];
                        return GestureDetector(
                          onTap: () => _onShapeTap(item),
                          child: ScaleTransition(
                            scale: _animation,
                            child: ShapeTile(
                              shapeItem: item,
                              isLearned: learningProvider.completedShapes.contains(item.name),
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
